{ stdenv
, fetchurl
# Note: If `{ static = false; shared = false; }`, upstream's default is used
#       (which is building both static and shared as of zlib 1.2.11).
, shared ? true
, static ? true
# If true, a separate .static ouput is created and the .a is moved there.
# In this case `pkg-config` auto detection does not currently work if the
# .static output is given as `buildInputs` to another package (#66461), because
# the `.pc` file lists only the main output's lib dir.
# If false, and if `{ static = true; }`, the .a stays in the main output.
, splitStaticOutput ? static
}:

assert splitStaticOutput -> static;

stdenv.mkDerivation (rec {
  name = "zlib-${version}";
  version = "1.2.11";

  src = fetchurl {
    urls =
      [ "https://www.zlib.net/fossils/${name}.tar.gz"  # stable archive path
        "mirror://sourceforge/libpng/zlib/${version}/${name}.tar.gz"
      ];
    sha256 = "c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1";
  };

  patches = stdenv.lib.optional stdenv.hostPlatform.isCygwin ./disable-cygwin-widechar.patch;

  postPatch = stdenv.lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace configure \
      --replace '/usr/bin/libtool' 'ar' \
      --replace 'AR="libtool"' 'AR="ar"' \
      --replace 'ARFLAGS="-o"' 'ARFLAGS="-r"'
  '';

  outputs = [ "out" "dev" ]
    ++ stdenv.lib.optional splitStaticOutput "static";
  setOutputFlags = false;
  outputDoc = "dev"; # single tiny man3 page

  # For zlib's ./configure (as of verion 1.2.11), the order
  # of --static/--shared flags matters!
  # `--shared --static` builds only static libs, while
  # `--static --shared` builds both.
  # So we use the latter order to be able to build both.
  # Also, giving just `--shared` builds both,
  # giving just `--static` builds only static,
  # and giving nothing builds both.
  # So we have 3 possible ways to build both:
  # `--static --shared`, `--shared` and giving nothing.
  # Of these, we choose `--shared`, only because that's
  # what we did in the past and we can avoid mass rebuilds this way.
  # As a result, we pass `--static` only when we want just static.
  configureFlags = stdenv.lib.optional (static && !shared) "--static"
                   ++ stdenv.lib.optional shared "--shared";

  # Note we don't need to set `dontDisableStatic`, because static-disabling
  # works by grepping for `enable-static` in the `./configure` script
  # (see `pkgs/stdenv/generic/setup.sh`), and zlib's handwritten one does
  # not have such.
  # It wouldn't hurt setting `dontDisableStatic = static && !splitStaticOutput`
  # here (in case zlib ever switches to autoconf in the future),
  # but we don't do it simply to avoid mass rebuilds.

  postInstall = stdenv.lib.optionalString splitStaticOutput ''
    moveToOutput lib/libz.a "$static"
  ''
    # jww (2015-01-06): Sometimes this library install as a .so, even on
    # Darwin; others time it installs as a .dylib.  I haven't yet figured out
    # what causes this difference.
  + stdenv.lib.optionalString stdenv.hostPlatform.isDarwin ''
    for file in $out/lib/*.so* $out/lib/*.dylib* ; do
      ${stdenv.cc.bintools.targetPrefix}install_name_tool -id "$file" $file
    done
  ''
    # Non-typical naming confuses libtool which then refuses to use zlib's DLL
    # in some cases, e.g. when compiling libpng.
  + stdenv.lib.optionalString (stdenv.hostPlatform.libc == "msvcrt") ''
    ln -s zlib1.dll $out/bin/libz.dll
  '';

  # As zlib takes part in the stdenv building, we don't want references
  # to the bootstrap-tools libgcc (as uses to happen on arm/mips)
  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString (!stdenv.hostPlatform.isDarwin) "-static-libgcc";

  # We don't strip on static cross-compilation because of reports that native
  # stripping corrupted the target library; see commit 12e960f5 for the report.
  dontStrip = stdenv.hostPlatform != stdenv.buildPlatform && static;
  configurePlatforms = [];

  installFlags = stdenv.lib.optionals (stdenv.hostPlatform.libc == "msvcrt") [
    "BINARY_PATH=$(out)/bin"
    "INCLUDE_PATH=$(dev)/include"
    "LIBRARY_PATH=$(out)/lib"
  ];

  enableParallelBuilding = true;
  doCheck = true;

  makeFlags = [
    "PREFIX=${stdenv.cc.targetPrefix}"
  ] ++ stdenv.lib.optionals (stdenv.hostPlatform.libc == "msvcrt") [
    "-f" "win32/Makefile.gcc"
  ] ++ stdenv.lib.optionals shared [
    # Note that as of writing (zlib 1.2.11), this flag only has an effect
    # for Windows as it is specific to `win32/Makefile.gcc`.
    "SHARED_MODE=1"
  ];

  passthru = {
    inherit version;
  };

  meta = with stdenv.lib; {
    homepage = https://zlib.net;
    description = "Lossless data-compression library";
    license = licenses.zlib;
    platforms = platforms.all;
  };
} // stdenv.lib.optionalAttrs (stdenv.hostPlatform != stdenv.buildPlatform) {
  preConfigure = ''
    export CHOST=${stdenv.hostPlatform.config}
  '';
} // stdenv.lib.optionalAttrs (stdenv.hostPlatform.libc == "msvcrt") {
  dontConfigure = true;
})
