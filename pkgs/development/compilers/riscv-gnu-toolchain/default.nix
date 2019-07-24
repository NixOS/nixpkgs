{ stdenv, gmp, mpfr, libmpc, wget, curl, texinfo, bison, flex, expat }:

with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "riscv-gnu-toolchain";
  
  buildInputs = [ gmp mpfr libmpc wget curl texinfo bison flex expat ];
  configureFlags = [ "--enable-multilib" ];
  hardeningDisable = [ "format" ];
  src = fetchgit {
    rev = "1321568527a6ac7d9ad464a425aa3baf11d0f300";
    url = "git://github.com/riscv/riscv-gnu-toolchain.git";
    sha256 = "131dgwlr60ilczixpqkdhb5hrjpasgh3yx78nvki7fbrxig5z47a";
  };

  meta = with stdenv.lib; {
    description = "GNU toolchain for RISC-V, including GCC";
    longDescription = "A GNU+Linux multilib (riscv64 and riscv32)
                       Newlib (libc) cross-compilation toolchain
                       oriented toward embedded systems
                       applications";
    homepage = https://github.com/riscv/riscv-gnu-toolchain;
    license = licenses.gpl2;
    maintainers = [ maintainers.jaykru ];
    platforms = platforms.all;
  };
}
