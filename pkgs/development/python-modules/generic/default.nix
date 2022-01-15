{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, poetry-core
}:

buildPythonPackage rec {
  pname = "generic";
  version = "1.0.1";
  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ex93I+ofo5lP6qoolZwzjxSspeqJimY3vpB32RLJ00k=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  pythonImportsCheck = [ "generic" ];

  meta = with lib; {
    description = "Generic programming (Multiple dispatch) library for Python";
    maintainers = with maintainers; [ wolfangaukang ];
    homepage = "https://github.com/gaphor/generic";
    license = licenses.bsdOriginal;
  };
}
