{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  unasync,
  boto3,
  botocore,
  requests,
  aiohttp,
  pyquery,
  loguru,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyhive-integration";
  version = "1.0.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Pyhass";
    repo = "Pyhiveapi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WGEwmvoUWo3T0A5QBkmomAMMfAEkGOtMZ2938GeOw1Y=";
  };

  pythonRemoveDeps = [ "pre-commit" ];

  build-system = [
    setuptools
    unasync
  ];

  dependencies = [
    boto3
    botocore
    requests
    aiohttp
    pyquery
    loguru
  ];

  # tests are not functional yet
  doCheck = false;

  postBuild = ''
    # pyhiveapi accesses $HOME upon importing
    export HOME=$TMPDIR
  '';

  pythonImportsCheck = [ "pyhiveapi" ];

  meta = {
    description = "Python library to interface with the Hive API";
    homepage = "https://github.com/Pyhass/Pyhiveapi";
    changelog = "https://github.com/Pyhass/Pyhiveapi/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
