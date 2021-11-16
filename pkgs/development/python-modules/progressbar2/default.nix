{ lib
, python
, buildPythonPackage
, fetchPypi
, python-utils
}:

buildPythonPackage rec {
  pname = "progressbar2";
  version = "3.55.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "86835d1f1a9317ab41aeb1da5e4184975e2306586839d66daf63067c102f8f04";
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
