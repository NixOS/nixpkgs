{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, pytestrunner, pytestcov, pytest-flakes, sphinx, six }:

buildPythonPackage rec {
  pname = "python-utils";
  version = "2.5.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "352d5b1febeebf9b3cdb9f3c87a3b26ef22d3c9e274a8ec1e7048ecd2fac4349";
  };

  postPatch = ''
    rm -r tests/__pycache__
    rm tests/*.pyc
    substituteInPlace pytest.ini --replace "--pep8" ""
  '';

  checkInputs = [ pytestCheckHook pytestrunner pytestcov pytest-flakes sphinx ];

  propagatedBuildInputs = [ six ];

  meta = with lib; {
    description = "Module with some convenient utilities";
    homepage = "https://github.com/WoLpH/python-utils";
    license = licenses.bsd3;
  };
}
