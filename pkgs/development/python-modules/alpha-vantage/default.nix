{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  pandas,
  pytestCheckHook,
  requests,
  requests-mock,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "alpha-vantage";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RomelTorres";
    repo = "alpha_vantage";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ae9WqEsAjJcD62NZOPh6a49g1wY4KMswzixDAZEtWkw=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "version='2.3.1'," "version='${finalAttrs.version}',"

    # Files are only linked
    rm alpha_vantage/async_support/*
    cp alpha_vantage/{cryptocurrencies.py,foreignexchange.py,techindicators.py,timeseries.py} alpha_vantage/async_support/
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    requests
  ];

  optional-dependencies = {
    pandas = [
      pandas
    ];
  };

  nativeCheckInputs = [
    aioresponses
    requests-mock
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  # Starting with 3.0.0 most tests require an API key
  doCheck = false;

  pythonImportsCheck = [ "alpha_vantage" ];

  meta = {
    description = "Python module for the Alpha Vantage API";
    homepage = "https://github.com/RomelTorres/alpha_vantage";
    changelog = "https://github.com/RomelTorres/alpha_vantage/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
