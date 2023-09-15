{ lib
, buildPythonPackage
, fetchPypi
, python
, pygments
}:

buildPythonPackage rec {
  pname = "catppuccin";
  version = "1.3.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iRQF9U6QvbyOSdp0OALc/Efl4IL1w17WGOZRbhzlqGA=";
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
