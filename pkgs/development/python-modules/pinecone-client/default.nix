{ lib
, buildPythonPackage
, dnspython
, fetchPypi
, loguru
, numpy
, poetry-core
, python-dateutil
, pythonOlder
, pythonRelaxDepsHook
, pyyaml
, requests
, setuptools
, tqdm
, typing-extensions
, urllib3
}:

buildPythonPackage rec {
  pname = "pinecone-client";
  version = "3.2.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "pinecone_client";
    inherit version;
    hash = "sha256-iHoSQF+QrBHDlkkPYF/EefMc8oI2EDTRrg/MwCrHW+4=";
  };

  pythonRelaxDeps = [
    "urllib3"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  build-system = [
    setuptools
    poetry-core
  ];

  dependencies = [
    dnspython
    loguru
    numpy
    python-dateutil
    pyyaml
    requests
    tqdm
    typing-extensions
    urllib3
  ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [
    "pinecone"
  ];

  meta = with lib; {
    description = "The Pinecone python client";
    homepage = "https://www.pinecone.io/";
    changelog = "https://github.com/pinecone-io/pinecone-python-client/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
