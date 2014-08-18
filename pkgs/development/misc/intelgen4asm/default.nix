{ stdenv, fetchgit, autoconf, automake, libtool, bison, flex }:

stdenv.mkDerivation rec {
  name = "intel-g4asm-20110416";
  
  src = fetchgit {
    url = http://anongit.freedesktop.org/git/xorg/app/intel-gen4asm.git;
    rev = "2450ff752642d116eb789a35393b9828133c7d31";
    sha256 = "a24c054a7c5ae335b72523fd2f51cae7f07a2885ef3c7a04d07a85e39f0c053f";
  };

  buildInputs = [ autoconf automake libtool bison flex ];

  preConfigure = "sh autogen.sh";

  meta = {
    homepage = http://cgit.freedesktop.org/xorg/app/intel-gen4asm/;
    license = "MIT";
    description = "Program to compile an assembly language for the Intel 965 Express Chipset";
  };
}
