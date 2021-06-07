{ lib
, buildPythonPackage
, fetchPypi
, mock
}:

buildPythonPackage rec {
  pname = "schedule";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1654cf70860a6d4d58236c98b0f1bb71521cc2a4bbf031b6cc39c96e77d59a91";
  };

  buildInputs = [ mock ];

  meta = with lib; {
    description = "Python job scheduling for humans";
    homepage = "https://github.com/dbader/schedule";
    license = licenses.mit;
  };

}
