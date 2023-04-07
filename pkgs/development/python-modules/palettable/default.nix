{ lib, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "palettable";
  version = "3.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-PsJCJw5K0EXAPQN+Wyj0d8wtCst/1ZJprW4NdWrMXqY=";
  };

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "A library of color palettes";
    homepage = "https://jiffyclub.github.io/palettable/";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}
