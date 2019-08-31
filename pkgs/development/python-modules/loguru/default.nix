{ lib, buildPythonPackage, fetchPypi, isPy27, pytest, colorama }:

buildPythonPackage rec {
  pname = "loguru";
  version = "0.3.1";
  
  disabled = isPy27;
  src = fetchPypi {
    inherit pname version;
    sha256 = "14pmxyx4kwyafdifqzal121mpdd89lxbjgn0zzi9z6fmzk6pr5h2";
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
