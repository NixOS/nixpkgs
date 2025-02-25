{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  pytest,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pytest-arraydiff";
  version = "0.6.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KTexRQ/JNWIPJHCdh9QMZ+BVoEPXuFQaJf36mU3aZ94=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ numpy ];

  # The tests requires astropy, which itself requires pytest-arraydiff
  doCheck = false;

  pythonImportsCheck = [ "pytest_arraydiff" ];

  meta = with lib; {
    description = "Pytest plugin to help with comparing array output from tests";
    homepage = "https://github.com/astrofrog/pytest-arraydiff";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
