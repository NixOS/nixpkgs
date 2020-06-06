{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  version = "1.5.1";
  pname = "bids-validator";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fy8w56m0x546zjk3is1xp83jm19fkn4y15g5jgmq29sfzc8n3y3";
  };

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = "Validator for the Brain Imaging Data Structure";
    homepage = "https://github.com/bids-standard/bids-validator";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
