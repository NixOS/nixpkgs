{ lib, buildPythonPackage, fetchPypi, pytest, pytestrunner, pytestcov, pytest-flakes, pytestpep8, sphinx, six }:

buildPythonPackage rec {
  pname = "python-utils";
  version = "2.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12c0glzkm81ljgf6pwh0d4rmdm1r7vvgg3ifzp8yp9cfyngw07zj";
  };

  postPatch = ''
    rm -r tests/__pycache__
    rm tests/*.pyc
  '';

  checkInputs = [ pytest pytestrunner pytestcov pytest-flakes pytestpep8 sphinx ];

  checkPhase = ''
    py.test tests
  '';

  propagatedBuildInputs = [ six ];

  meta = with lib; {
    description = "Module with some convenient utilities";
    homepage = "https://github.com/WoLpH/python-utils";
    license = licenses.bsd3;
  };
}
