{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  pytest-asyncio,
  pytest-httpserver,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  requests,
  setuptools,
  tomli,
  tomli-w,
  types-pyyaml,
  types-toml,
  urllib3,
}:

buildPythonPackage rec {
  pname = "responses";
  version = "0.25.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-FHtuZ6NUmCveAJOXEajfTLRMR8W1Jz/pjFKdE6PHW2g=";
  };

  patches = [
    (fetchpatch2 {
      # adds missing pytest asyncio markers
      url = "https://github.com/getsentry/responses/commit/d5e7402f1782692d04742562370abaca8d54a972.patch";
      hash = "sha256-A/DYSKvuangolkcQX4k/uom//AQ9in7BsTmVtlCqmXQ=";
    })
  ];

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    pyyaml
    requests
    types-pyyaml
    types-toml
    urllib3
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-httpserver
    pytestCheckHook
    tomli-w
  ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  pythonImportsCheck = [ "responses" ];

  meta = with lib; {
    description = "Python module for mocking out the requests Python library";
    homepage = "https://github.com/getsentry/responses";
    changelog = "https://github.com/getsentry/responses/blob/${version}/CHANGES";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
