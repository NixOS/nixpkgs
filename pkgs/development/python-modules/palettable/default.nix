{ lib, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "palettable";
  version = "3.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-aoZ8Qlov8ojqtDVr7ewA3gBt7jbJmmFHwuGwXeeJrJ8=";
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
