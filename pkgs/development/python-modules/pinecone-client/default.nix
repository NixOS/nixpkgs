{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, poetry-core
, pythonRelaxDepsHook
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
  version = "3.2.1";
  pyproject = true;

  src = fetchPypi {
    pname = "pinecone_client";
    inherit version;
    hash = "sha256-hWD/r7E7nEWpLrnrd6LbMtWh+nkDodsX969Y7hBYu2A=";
  };

  nativeBuildInputs = [
    setuptools
    poetry-core
    pythonRelaxDepsHook
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

  pythonRelaxDeps = [
    "urllib3"
  ];

  doCheck = false;

  pythonImportsCheck = [
    "pinecone"
  ];

  meta = with lib; {
    homepage = "https://www.pinecone.io/";
    description = "The Pinecone python client";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
