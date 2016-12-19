{ stdenv, fetchFromGitHub, python, llvm, clang }:

stdenv.mkDerivation {
  name = "libclc-2015-08-07";

  src = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libclc";
    rev = "f97d9db40718f2e68b3f0b44200760d8e0d50532";
    sha256 = "10n9qk1dild9yjkjjkzpmp9zid3ysdgvqrad554azcf755frch7g";
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
