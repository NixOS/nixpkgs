args : with args; 
rec {
  src = fetchurl {
    url = http://llvm.org/releases/2.2/llvm-gcc4.2-2.2.source.tar.gz;
    sha256 = "11vjn8wn76cq63jam7y5ralq1b12r6cdipf22nsnzw90srb49qkp";
  };

  buildInputs = [llvm bison flex perl mpfr gmp];
  configureFlags = [" --enable-llvm=$(ls -d $PWD/../llvm-?.?) "];
  makeFlags = [" -f Makefile "];

  phaseNames = ["preConfigure" "doConfigure" "doMakeInstall"];

  preConfigure = FullDepEntry (''
    cd ..
    mkdir obj install
    tar xf ${llvmSrc}
    cd obj
  '') ["doUnpack" "minInit"];
  configureCommand = "$(ls ../llvm-gcc*.*.source/configure)";
  
  name = "llvm-gcc42-2.2";
  meta = {
    description = "LLVM GCC frontend";
  };
}

  
