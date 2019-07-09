{ lib, buildPythonPackage, fetchPypi, isPy27, pytest, colorama }:

buildPythonPackage rec {
  pname = "loguru";
  version = "0.3.0";
  
  disabled = isPy27;
  src = fetchPypi {
    inherit pname version;
    sha256 = "1b2phizcx2wbdm5np0s16yd68fc0isqnm8qs6l9pmlrlyf9gm87j";
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
