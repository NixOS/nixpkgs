{ lib, buildPythonPackage, fetchFromGitHub, cython, mkl, nose, six }:

buildPythonPackage rec {
  pname = "mkl-service";
  version = "2.4.0.post1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "IntelPython";
    repo = "mkl-service";
    rev = "v${version}";
    sha256 = "0ysjn8z1hkscb4cycbrvcb93r04w5793yylsy40h5dvjd04ns5jc";
  };

  MKLROOT = mkl;

  nativeCheckInputs = [ nose ];
  nativeBuildInputs = [ cython ];
  propagatedBuildInputs = [ mkl six ];

  meta = with lib; {
    description = "Python hooks for Intel(R) Math Kernel Library runtime control settings";
    homepage = "https://github.com/IntelPython/mkl-service";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bhipple ];
  };
}
