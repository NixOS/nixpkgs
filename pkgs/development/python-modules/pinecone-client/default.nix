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
  version = "2.2.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-F2mWUpFMn2ipopa3UjvzrmNZsHtdRrUwfkuHbDYBElo=";
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
