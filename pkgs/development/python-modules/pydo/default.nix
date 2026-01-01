{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  aioresponses,
  azure-core,
  azure-identity,
  isodate,
  msrest,
  responses,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "pydo";
<<<<<<< HEAD
  version = "0.23.0";
=======
  version = "0.21.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "digitalocean";
    repo = "pydo";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-wmrth6n6vlYLMMiNYm6p5sS2keEFsnGm9sGjShSsLaA=";
=======
    hash = "sha256-pCvJ8UY5hvmlUAQ3oMdnDVhK0x/5iFBpaw3/W9RV8Z0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ poetry-core ];

  dependencies = [
    aioresponses
    azure-core
    azure-identity
    isodate
    msrest
    responses
  ];

  pythonImportsCheck = [ "pydo" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  # integration tests require hitting the live api with a
  # digital ocean token
  disabledTestPaths = [
    "tests/integration/"
  ];

  meta = {
    description = "Official DigitalOcean Client based on the DO OpenAPIv3 specification";
    homepage = "https://github.com/digitalocean/pydo";
    changelog = "https://github.com/digitalocean/pydo/releases/tag/v${version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
}
