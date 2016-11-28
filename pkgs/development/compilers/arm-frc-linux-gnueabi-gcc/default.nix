{stdenv, fetchurl
}:

stdenv.mkDerivation rec {
  _target = "arm-frc-linux-gnueabi";

  version = "4.9.4";
  name = "${_target}-gcc-${version}";

  src = fetchurl {
    url = "ftp://gcc.gnu.org/pub/gcc/releases/gcc-${version}/gcc-${version}.tar.bz2";
    sha256 = "0n2yx3gjlpr4kgqx845fj6amnmg25r2l6a7rzab5hxnpmar985hc";
  };

  buildInputs = [${_target}-binutils ${_target}-eglibc elfutils libmpc];

  patches =
  [
    ./minorSOname.patch
    ./no-nested-deprecated-warnings.patch
  ]

  configureFlags = "
  --prefix=/usr
  --program-prefix=${_target}-
  --target=${_target}
  --host=$CHOST
  --build=$CHOST
  --enable-shared
  --disable-nls
  --enable-threads=posix
  --enable-languages=c,c++
  --disable-multilib
  --disable-multiarch
  --with-sysroot=/usr/${_target}
  --with-build-sysroot=/usr/${_target}
  --with-as=/usr/bin/${_target}-as
  --with-ld=/usr/bin/${_target}-ld
  --with-cpu=cortex-a9
  --with-float=softfp
  --with-fpu=vfp
  --with-specs='%{save-temps: -fverbose-asm} %{funwind-tables|fno-unwind-tables|mabi=*|ffreestanding|nostdlib:;:-funwind-tables}' //TODO: FIX THIS SHIT
  --enable-lto
  --with-pkgversion='GCC for FRC'
  --with-cloog
  --enable-poison-system-directories
  --enable-plugin
  --with-system-zlib
  --disable-libmudflap
  ";

  buildFlags = "all-gcc all-target-libgcc all-target-libstdc++-v3";

  installTargets = "install-gcc install-target-libgcc install-target-libstdc++-v3";
}
