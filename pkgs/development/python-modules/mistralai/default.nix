{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonPackage rec {
  pname = "mistralai";
  version = "1.9.11";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PfnkA8MadW7HnnjfJe5zzqPrFfhmk3c+FrFq2vWcm4o=";
  };

  build-system = [ python3Packages.poetry-core ];

  dependencies = with python3Packages; [
    eval-type-backport
    httpx
    invoke
    pydantic
    python-dateutil
    pyyaml
    typing-inspection
  ];

  optional-dependencies = with python3Packages; {
    agents = [
      authlib
      griffe
      mcp
    ];
    gcp = [
      google-auth
      requests
    ];
  };

  pythonImportsCheck = [ "mistralai" ];

  meta = {
    description = "Python Client SDK for the Mistral AI API";
    homepage = "https://pypi.org/project/mistralai/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mana-byte ];
  };
}
