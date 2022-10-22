{ lib
, python
, buildPythonPackage
, fetchPypi
, python-utils
}:

buildPythonPackage rec {
  pname = "progressbar2";
  version = "4.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Y5odWSJ4RIg5kwvf/SQrTU6pzgyeZWrqgQKCwtNrwSE=";
  };

  propagatedBuildInputs = [ python-utils ];

  pythonImportsCheck = [ "progressbar" ];

  meta = with lib; {
    homepage = "https://progressbar-2.readthedocs.io/en/latest/";
    description = "Text progressbar library for python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ashgillman turion ];
  };
}
