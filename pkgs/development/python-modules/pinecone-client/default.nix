{ lib
, buildPythonPackage
, fetchPypi
, numpy
, pyyaml
, python-dateutil
, urllib3
, tqdm
, dnspython
, requests
, typing-extensions
, loguru
}:
buildPythonPackage rec {
  pname = "pinecone-client";
  version = "2.2.4";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LBzB1mSLK+ZulE2y/6WRZqN7kWTRE1rVJdnNix4pgWg=";
  };

  propagatedBuildInputs = [
    numpy
    pyyaml
    python-dateutil
    urllib3
    tqdm
    dnspython
    requests
    typing-extensions
    loguru
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://www.pinecone.io/";
    description = "The Pinecone python client";
    license = licenses.mit;
    maintainers = with maintainers; [happysalada];
  };
}
