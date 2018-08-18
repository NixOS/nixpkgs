{ stdenv
, fetchurl
, buildPlatform, hostPlatform
, static ? false
}:

stdenv.mkDerivation rec {
  name = "zlib-${version}";
  version = "1.2.11";

  src = fetchurl {
    urls =
      [ "https://www.zlib.net/fossils/${name}.tar.gz"  # stable archive path
        "mirror://sourceforge/libpng/zlib/${version}/${name}.tar.gz"
      ];
    sha256 = "c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1";
  };

  patches = stdenv.lib.optional hostPlatform.isCygwin ./disable-cygwin-widechar.patch;

  postPatch = stdenv.lib.optionalString hostPlatform.isDarwin ''
    substituteInPlace configure \
      --replace '/usr/bin/libtool' 'ar' \
      --replace 'AR="libtool"' 'AR="ar"' \
      --replace 'ARFLAGS="-o"' 'ARFLAGS="-r"'
  '';

  outputs = [ "out" "dev" "static" ];
  setOutputFlags = false;
  outputDoc = "dev"; # single tiny man3 page

  configureFlags = stdenv.lib.optional (!static) "--shared";

  postInstall = ''
    moveToOutput lib/libz.a "$static"
  ''
    # jww (2015-01-06): Sometimes this library install as a .so, even on
    # Darwin; others time it installs as a .dylib.  I haven't yet figured out
    # what causes this difference.
  + stdenv.lib.optionalString hostPlatform.isDarwin ''
    for file in $out/lib/*.so* $out/lib/*.dylib* ; do
      install_name_tool -id "$file" $file
    done
  ''
    # Non-typical naming confuses libtool which then refuses to use zlib's DLL
    # in some cases, e.g. when compiling libpng.
  + stdenv.lib.optionalString (hostPlatform.libc == "msvcrt") ''
    ln -s zlib1.dll $out/bin/libz.dll
  '';

  # As zlib takes part in the stdenv building, we don't want references
  # to the bootstrap-tools libgcc (as uses to happen on arm/mips)
  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString (!hostPlatform.isDarwin) "-static-libgcc";

  dontStrip = hostPlatform != buildPlatform && static;
  configurePlatforms = [];

  installFlags = stdenv.lib.optionals (hostPlatform.libc == "msvcrt") [
    "BINARY_PATH=$(out)/bin"
    "INCLUDE_PATH=$(dev)/include"
    "LIBRARY_PATH=$(out)/lib"
  ];

  makeFlags = [
    "PREFIX=${stdenv.cc.targetPrefix}"
  ] ++ stdenv.lib.optionals (hostPlatform.libc == "msvcrt") [
    "-f" "win32/Makefile.gcc"
  ] ++ stdenv.lib.optionals (!static) [
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
}
