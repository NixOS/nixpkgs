{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "pathtools";
  version = "0.1.2";
  format = "setuptools";

  # imp and distuils usage, last commit in 2016
  disabled = pythonAtLeast "3.12";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fDXFQho5u4LlgBj+vZDjtuXbNMVEOqr3QrPzPUZV8cA=";
  };

  meta = with lib; {
    description = "Pattern matching and various utilities for file systems paths";
    homepage = "https://github.com/gorakhargosh/pathtools";
    license = licenses.mit;
    maintainers = with maintainers; [ goibhniu ];
  };
}
