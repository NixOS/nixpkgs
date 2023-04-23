{ lib
, buildPythonPackage
, fetchPypi
, python
, pygments
}:

buildPythonPackage rec {
  pname = "catppuccin";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mHNuV3yIuFL2cixDOr+//+/b9iD2fN82cfLzZkegxKc=";
  };

  propagatedBuildInputs = [ pygments ];

  pythonImportsCheck = [ "catppuccin" ];

  meta = with lib; {
    description = "Soothing pastel theme for Python";
    homepage = "https://github.com/catppuccin/python";
    maintainers = with maintainers; [ fufexan ];
    license = licenses.mit;
  };
}
