{ buildPythonPackage
, aiohttp
, attrs
, cachetools
, click
, deprecation
, fetchPypi
, lib
, overrides
, pydantic
, pylance
, pythonRelaxDepsHook
, pyyaml
, requests
, retry
, semver
, setuptools
, tqdm
}:

buildPythonPackage rec {
  pname = "lancedb";
  version = "0.3.3";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jYqcKxBxVO5X9vdZV9IVcZogTNZMnvvnCV6vQbQ8Kik=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools
  ];

  pythonRemoveDeps = [ "ratelimiter" ];

  propagatedBuildInputs = [
    aiohttp
    attrs
    cachetools
    click
    deprecation
    overrides
    pydantic
    pylance
    pyyaml
    requests
    retry
    semver
    tqdm
  ];

  meta = {
    description = "Serverless vector database";
    homepage = "https://lancedb.github.io/lancedb/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ elohmeier ];
  };
}
