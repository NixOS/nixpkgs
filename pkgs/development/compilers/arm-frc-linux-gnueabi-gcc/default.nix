{stdenv, fetchurl
, arm-frc-linux-gnueabi-binutils, arm-frc-linux-gnueabi-eglibc, arm-frc-linux-gnueabi-linux-api-headers
, elfutils
, libmpc, gmp, mpfr, zlib, isl_0_15, cloog}:

stdenv.mkDerivation rec {
  _target = "arm-frc-linux-gnueabi";

  version = "4.9.4";
  name = "${_target}-gcc-${version}";

  src = fetchurl {
    url = "ftp://gcc.gnu.org/pub/gcc/releases/gcc-${version}/gcc-${version}.tar.bz2";
    sha256 = "6c11d292cd01b294f9f84c9a59c230d80e9e4a47e5c6355f046bb36d4f358092";
  };

  patches = [
    ./minorSOname.patch
    ./no-nested-deprecated-warnings.patch
  ];

  hardeningDisable = [ "format" ];

  buildInputs = [
    arm-frc-linux-gnueabi-binutils
    arm-frc-linux-gnueabi-eglibc
    arm-frc-linux-gnueabi-linux-api-headers
    elfutils
    libmpc
    gmp
    mpfr
    zlib
    isl_0_15
    cloog
  ];


  configurePhase = ''
    mkdir gcc-build
    cd gcc-build
    ../configure \
      --prefix=$out \
      --host=$CHOST \
      --build=$CHOST \
      --program-prefix=${_target}- \
      --target=${_target} \
      --enable-shared \
      --disable-nls \
      --enable-threads=posix \
      --enable-languages=c,c++ \
      --disable-multilib \
      --disable-multiarch \
      --with-sysroot=${arm-frc-linux-gnueabi-eglibc}/${_target} \
      --with-build-sysroot=${arm-frc-linux-gnueabi-eglibc}/${_target} \
      --with-as=${arm-frc-linux-gnueabi-binutils}/${_target}/bin/as \
      --with-ld=${arm-frc-linux-gnueabi-binutils}/${_target}/bin/ld \
      --with-cpu=cortex-a9 \
      --with-float=softfp \
      --with-fpu=vfp \
      --with-specs='%{save-temps:-fverbose-asm} %{funwind-tables|fno-unwind-tables|mabi=*|ffreestanding|nostdlib:;:-funwind-tables}' \
      --enable-lto \
      --with-pkgversion='GCC-for-FRC' \
      --with-cloog \
      --enable-poison-system-directories \
      --enable-plugin \
      --with-system-zlib \
      --disable-libmudflap \
      --disable-libsanitizer
  '';

  makeFlags = [
    "all-gcc"
    "all-target-libgcc"
    "all-target-libstdc++-v3"
  ];

  installPhase = ''
    make install-gcc install-target-libgcc install-target-libstdc++-v3
  '';

  postInstall = ''
    rm -rf $out/share/{man/man7,info}/ "$out/share/gcc-${version}/python"
  '';

  meta = with stdenv.lib; {
    description = "FRC cross compiler";
    longDescription = ''
      arm-frc-linux-gnueabi-gcc is a cross compiler for building
      code for FIRST Robotics Competition. Used as a cross compiler
      for the NI RoboRio.
    '';
    license = licenses.gpl2;
    maintainers = [ maintainers.colescott ];
    platforms = platforms.linux;

    priority = 4;
  };
}
