{ lib, buildPythonPackage, fetchFromGitHub, cython, mkl, nose, six }:

buildPythonPackage rec {
  pname = "mkl-service";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "IntelPython";
    repo = "mkl-service";
    rev = "v${version}";
    sha256 = "1bnpgx629rxqf0yhn0jn68ypj3dqv6njc3981j1g8j8rsm5lycrn";
  };

  MKLROOT = mkl;

  checkInputs = [ nose ];
  nativeBuildInputs = [ cython ];
  propagatedBuildInputs = [ mkl six ];

  meta = with lib; {
    description = "Python hooks for Intel(R) Math Kernel Library runtime control settings";
    homepage = "https://github.com/IntelPython/mkl-service";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bhipple ];
  };
}
