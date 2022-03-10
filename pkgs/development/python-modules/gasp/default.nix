{ lib, buildPythonPackage, fetchPypi, pythonOlder,
fetchgit, tkinter, pygame, python3, xvfb-run }:

buildPythonPackage rec {
  pname = "gasp";
  version = "0.6.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-3h90H+E0pvDtpT/eQUsLjnnFholbxxk7K66exB6W3vo=";
  };

  propagatedBuildInputs = [ tkinter pygame ];
  checkInputs = [ xvfb-run tkinter pygame ];

  dontUsePythonRemoveTestsDir = true;

  checkPhase = ''
    xvfb-run -s '-screen 0 800x600x24' ${python3.interpreter} tests/test_graphics.py
  '';

  pythonImportsCheck = [ "gasp" ];

  meta = with lib; {
    homepage = "https://codeberg.org/GASP/GASP_Code";
    description = "Module which helps to write 1980's style arcade games.";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ thehedgeh0g ];
  };
}
