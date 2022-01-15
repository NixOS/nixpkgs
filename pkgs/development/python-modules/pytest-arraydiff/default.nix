{ lib
, buildPythonPackage
, fetchPypi
, numpy
, pytest
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pytest-arraydiff";
  version = "0.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "714149beffd0dfa085477c65791c1139b619602b049536353ce1a91397fb3bd2";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    numpy
  ];

  # The tests requires astropy, which itself requires pytest-arraydiff
  doCheck = false;

  pythonImportsCheck = [
    "pytest_arraydiff"
  ];

  meta = with lib; {
    description = "Pytest plugin to help with comparing array output from tests";
    homepage = "https://github.com/astrofrog/pytest-arraydiff";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
