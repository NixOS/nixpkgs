{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, exceptiongroup
, poetry-core
}:

buildPythonPackage rec {
  pname = "generic";
  version = "1.1.1";
  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UHz2v6K5lNYb7cxBViTfPkpu2M8LItApGoSg3Bb2bqI=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    exceptiongroup
  ];

  pythonImportsCheck = [ "generic" ];

  meta = with lib; {
    description = "Generic programming (Multiple dispatch) library for Python";
    maintainers = with maintainers; [ wolfangaukang ];
    homepage = "https://github.com/gaphor/generic";
    license = licenses.bsdOriginal;
  };
}
