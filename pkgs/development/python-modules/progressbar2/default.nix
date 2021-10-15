{ lib
, python
, buildPythonPackage
, fetchPypi
, python-utils
}:

buildPythonPackage rec {
  pname = "progressbar2";
  version = "3.54.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d878893cda2f477c63b5bd0f7f5301f03dd0a81c02554a1f2c5562036369376a";
  };

  propagatedBuildInputs = [ python-utils ];

  # depends on unmaintained pytest-pep8
  # https://github.com/WoLpH/python-progressbar/issues/241
  doCheck = false;

  pythonImportsCheck = [ "progressbar" ];

  meta = with lib; {
    homepage = "https://progressbar-2.readthedocs.io/en/latest/";
    description = "Text progressbar library for python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ashgillman turion ];
  };
}
