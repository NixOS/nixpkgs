{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
  invoke,
}:

buildPythonPackage rec {
  pname = "pylnk3";
  version = "0.4.3";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "pylnk3";
    hash = "sha256-+8X1ErWBOCwqTBHm3zeW+Zdbz9meP8oq/lMephs8SsI=";
  };

  propagatedBuildInputs = [
    pytest
    invoke
  ];
  # There are no tests in pylnk3.
  doCheck = false;

  pythonImportsCheck = [ "pylnk3" ];

  meta = {
    description = "Python library for reading and writing Windows shortcut files (.lnk)";
    mainProgram = "pylnk3";
    homepage = "https://github.com/strayge/pylnk";
    license = with lib.licenses; [ lgpl3Only ];
    maintainers = with lib.maintainers; [ fedx-sudo ];
  };
}
