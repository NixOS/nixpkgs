{ stdenv, fetchurl, static ? false }:

let version = "1.2.8"; in

stdenv.mkDerivation rec {
  name = "zlib-${version}";

  src = fetchurl {
    urls =
      [ "http://www.zlib.net/fossils/${name}.tar.gz"  # stable archive path
        "mirror://sourceforge/libpng/zlib/${version}/${name}.tar.gz"
      ];
    sha256 = "039agw5rqvqny92cpkrfn243x2gd4xn13hs3xi6isk55d2vqqr9n";
  };

  patches = [
    ./CVE-2016-9840.patch
    ./CVE-2016-9841.patch
    ./CVE-2016-9842.patch
    ./CVE-2016-9843.patch
  ];

  postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace configure \
      --replace '/usr/bin/libtool' 'ar' \
      --replace 'AR="libtool"' 'AR="ar"' \
      --replace 'ARFLAGS="-o"' 'ARFLAGS="-r"'
  '';

  outputs = [ "out" "dev" "static" ];
  setOutputFlags = false;
  outputDoc = "dev"; # single tiny man3 page


  preConfigure = ''
    if test -n "$crossConfig"; then
      export CC=$crossConfig-gcc
    fi
  '';

  # FIXME needs gcc 4.9 in bootstrap tools
  hardeningDisable = [ "stackprotector" ];

  configureFlags = stdenv.lib.optional (!static) "--shared";

  postInstall = ''
    moveToOutput lib/libz.a "$static"
  ''
    # jww (2015-01-06): Sometimes this library install as a .so, even on
    # Darwin; others time it installs as a .dylib.  I haven't yet figured out
    # what causes this difference.
  + stdenv.lib.optionalString stdenv.isDarwin ''
    for file in $out/lib/*.so* $out/lib/*.dylib* ; do
      install_name_tool -id "$file" $file
    done
  '';

  # As zlib takes part in the stdenv building, we don't want references
  # to the bootstrap-tools libgcc (as uses to happen on arm/mips)
  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString (!stdenv.isDarwin) "-static-libgcc";

  crossAttrs = {
    dontStrip = static;
    dontSetConfigureCross = true;
  } // stdenv.lib.optionalAttrs (stdenv.cross.libc == "msvcrt") {
    installFlags = [
      "BINARY_PATH=$(out)/bin"
      "INCLUDE_PATH=$(dev)/include"
      "LIBRARY_PATH=$(out)/lib"
    ];
    makeFlags = [
      "-f" "win32/Makefile.gcc"
      "PREFIX=${stdenv.cross.config}-"
    ] ++ stdenv.lib.optional (!static) "SHARED_MODE=1";

    # Non-typical naming confuses libtool which then refuses to use zlib's DLL
    # in some cases, e.g. when compiling libpng.
    postInstall = postInstall + "ln -s zlib1.dll $out/bin/libz.dll";
  } // stdenv.lib.optionalAttrs (stdenv.cross.libc == "libSystem") {
    makeFlags = [ "RANLIB=${stdenv.cross.config}-ranlib" ];
  };

  passthru.version = version;

  meta = with stdenv.lib; {
    description = "Lossless data-compression library";
    license = licenses.zlib;
    platforms = platforms.all;
  };
}
