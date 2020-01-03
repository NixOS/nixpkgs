{ lib, buildPythonPackage, fetchPypi, isPy27, pytest, colorama }:

buildPythonPackage rec {
  pname = "loguru";
  version = "0.3.2";
  
  disabled = isPy27;
  src = fetchPypi {
    inherit pname version;
    sha256 = "0apd3wcjbyhwzgw0fgzzn4dcgy10pqa8f1vf58d4hmszxvyqn4z3";
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
