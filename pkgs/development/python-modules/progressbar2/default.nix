{ lib
, python
, buildPythonPackage
, fetchPypi
, python-utils
}:

buildPythonPackage rec {
  pname = "progressbar2";
  version = "3.53.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8c150baaa33448c1e34a2cafa5108285d96f2c877bdf64fcbd77f26cb135435d";
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
