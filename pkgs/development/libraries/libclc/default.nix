{ stdenv, fetchFromGitHub, python2, llvm_40, clang }:

stdenv.mkDerivation {
  name = "libclc-2017-02-25";

  src = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libclc";
    rev = "17648cd846390e294feafef21c32c7106eac1e24";
    sha256 = "1c20jyh3sdwd9r37zs4vvppmsx8vhf2xbx0cxsrc27bhx5245p0s";
  };

  buildInputs = [ python2 llvm_40 clang ];

  postPatch = ''
    sed -i 's,llvm_clang =.*,llvm_clang = "${clang}/bin/clang",' configure.py
    sed -i 's,cxx_compiler =.*,cxx_compiler = "${clang}/bin/clang++",' configure.py
  '';

  configurePhase = ''
    ${python2.interpreter} ./configure.py --prefix=$out
  '';

  meta = with stdenv.lib; {
    homepage = http://libclc.llvm.org/;
    description = "Implementation of the library requirements of the OpenCL C programming language";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
