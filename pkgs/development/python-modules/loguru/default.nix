{ lib, buildPythonPackage, fetchPypi, isPy27, pytest, colorama }:

buildPythonPackage rec {
  pname = "loguru";
  version = "0.4.0";
  
  disabled = isPy27;
  src = fetchPypi {
    inherit pname version;
    sha256 = "d5ddf363b7e0e562652f283f74a89bf35601baf16b70f2cd2736a2f8c6638748";
  };

  checkInputs = [ pytest colorama ];
  checkPhase = ''
    pytest -k 'not test_time_rotation_reopening'
  '';

  meta = with lib; {
    homepage = https://github.com/Delgan/loguru;
    description = "Python logging made (stupidly) simple";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
