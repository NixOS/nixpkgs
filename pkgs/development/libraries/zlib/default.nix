{ stdenv
, fetchurl
, static ? true
, shared ? true
}:

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
    ++ stdenv.lib.optional (shared && static) "static";
  setOutputFlags = false;
  outputDoc = "dev"; # single tiny man3 page

  configureFlags = stdenv.lib.optional shared "--shared"
                   ++ stdenv.lib.optional (static && !shared) "--static";

  postInstall = stdenv.lib.optionalString (shared && static) ''
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

  dontStrip = stdenv.hostPlatform != stdenv.buildPlatform && static;
  configurePlatforms = [];

  installFlags = stdenv.lib.optionals (stdenv.hostPlatform.libc == "msvcrt") [
    "BINARY_PATH=$(out)/bin"
    "INCLUDE_PATH=$(dev)/include"
    "LIBRARY_PATH=$(out)/lib"
  ];

  makeFlags = [
    "PREFIX=${stdenv.cc.targetPrefix}"
  ] ++ stdenv.lib.optionals (stdenv.hostPlatform.libc == "msvcrt") [
    "-f" "win32/Makefile.gcc"
  ] ++ stdenv.lib.optionals shared [
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
  configurePhase = ":";
})
