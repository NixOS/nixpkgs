{ stdenv, buildPackages
, fetchurl, autoreconfHook264, bison, binutils-unwrapped
, libiberty, libbfd
}:

stdenv.mkDerivation rec {
  name = "libopcodes-${version}";
  inherit (binutils-unwrapped) version src;

  outputs = [ "out" "dev" ];

  patches = binutils-unwrapped.patches ++ [
    ../../tools/misc/binutils/build-components-separately.patch
  ];

  # We just want to build libopcodes
  postPatch = ''
    cd opcodes
    find . ../include/opcode -type f -exec sed {} -i -e 's/"bfd.h"/<bfd.h>/' \;
  '';

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ autoreconfHook264 bison ];
  buildInputs = [ libiberty ];
  # dis-asm.h includes bfd.h
  propagatedBuildInputs = [ libbfd ];

  configurePlatforms = [ "build" "host" ];
  configureFlags = [
    "--enable-targets=all" "--enable-64-bit-bfd"
    "--enable-install-libbfd"
    "--enable-shared"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A library from binutils for manipulating machine code";
    homepage = http://www.gnu.org/software/binutils/;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ericson2314 ];
    platforms = platforms.unix;
  };
}
