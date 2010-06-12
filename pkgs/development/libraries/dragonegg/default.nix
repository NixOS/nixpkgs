{stdenv, fetchsvn, llvm}:

stdenv.mkDerivation {
  name = "dragonegg-2.7";

  GCC = "gcc";

  buildInputs = [ llvm ];

  src = fetchsvn {
    url = http://llvm.org/svn/llvm-project/dragonegg/branches/release_27;
    rev = 105882;
    sha256 = "0j0mj3zm1nd8kaj3b28b3w2dlzc1xbywq4mcdxk5nq4yds6rx5np";
  };
}
