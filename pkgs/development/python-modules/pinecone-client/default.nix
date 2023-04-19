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
  version = "2.2.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CHjcruRHxGyNGz1xyFRonap+VI5QCaFxeAkHx9TnR4k=";
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
