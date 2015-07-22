{ stdenv, fetchFromGitHub, python, llvm, clang }:

stdenv.mkDerivation {
  name = "libclc-2015-03-27";

  src = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libclc";
    rev = "0a2d1619921545b52303be5608b64dc46f381e97";
    sha256 = "0hgm013c0vlfqfbbf4cdajl01hhk1mhsfk4h4bfza1san97l0vcc";
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
    description = "Implementation of the library requirements of the OpenCL C programming language";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
