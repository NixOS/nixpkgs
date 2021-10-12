{ lib
, python
, buildPythonPackage
, fetchPypi
, python-utils
}:

buildPythonPackage rec {
  pname = "progressbar2";
  version = "3.53.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f4e1c2d48e608850c59f793d6e74ccdebbcbaac7ffe917d45e9646ec0d664d6d";
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
