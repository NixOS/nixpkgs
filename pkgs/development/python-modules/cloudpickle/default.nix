{ lib, buildPythonPackage, fetchFromGitHub, isPy27, pytest, mock }:

buildPythonPackage rec {
  pname = "cloudpickle";
  version = "1.6.0";
  disabled = isPy27; # abandoned upstream

  src = fetchFromGitHub {
     owner = "cloudpipe";
     repo = "cloudpickle";
     rev = "v1.6.0";
     sha256 = "1584d21d4rcpryn8yfz0pjnjprk4zm367m0razdcz8cjbsh0dxp6";
  };

  buildInputs = [ pytest mock ];

  # See README for tests invocation
  checkPhase = ''
    PYTHONPATH=$PYTHONPATH:'.:tests' py.test
  '';

  # TypeError: cannot serialize '_io.FileIO' object
  doCheck = false;

  meta = with lib; {
    description = "Extended pickling support for Python objects";
    homepage = "https://github.com/cloudpipe/cloudpickle";
    license = with licenses; [ bsd3 ];
  };
}
