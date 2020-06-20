{ lib, buildPythonPackage, fetchFromGitHub, cython, mkl, nose, six }:

buildPythonPackage rec {
  pname = "mkl-service";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "IntelPython";
    repo = "mkl-service";
    rev = "v${version}";
    sha256 = "1b4dkkl439rfaa86ywzc2zf9ifawhvdlaiqcg0il83cn5bzs7g5z";
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
