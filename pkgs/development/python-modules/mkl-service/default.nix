{ lib, buildPythonPackage, fetchFromGitHub, cython, mkl, nose, six }:

buildPythonPackage rec {
  pname = "mkl-service";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "IntelPython";
    repo = "mkl-service";
    rev = "v${version}";
    sha256 = "1x8j0ij582dyhay0gaqq45a2jz1m4fr8xw0v65ngviajj3cxmcpb";
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
