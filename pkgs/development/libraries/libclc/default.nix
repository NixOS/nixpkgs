{ stdenv, fetchsvn, python, llvm, clang }:

stdenv.mkDerivation {
  name = "libclc-2015-03-27";

  src = fetchsvn {
    url = "http://llvm.org/svn/llvm-project/libclc/trunk";
    rev = "233456";
    sha256 = "0g56kgffc1qr9rzhcjr4w8kljcicg0q828s9b4bmfzjvywd7hhr0";
  };

  buildInputs = [ python llvm clang ];

  postPatch = ''
    sed -i 's,llvm_clang =.*,llvm_clang = "${clang}/bin/clang",' configure.py
    sed -i 's,cxx_compiler =.*,cxx_compiler = "${clang}/bin/clang++",' configure.py
  '';

  configurePhase = ''
    python2 ./configure.py --prefix=$out
  '';

  meta = with stdenv.lib; {
    homepage = http://libclc.llvm.org/;
    description = "implementation of the library requirements of the OpenCL C programming language";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
