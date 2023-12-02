{ lib
, buildPythonPackage
, fetchPypi
, setuptools
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
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-F2mWUpFMn2ipopa3UjvzrmNZsHtdRrUwfkuHbDYBElo=";
  };

  nativeBuildInputs = [
    setuptools
  ];

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
