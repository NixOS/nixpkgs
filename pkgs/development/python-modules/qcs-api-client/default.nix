{ lib
, attrs
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, httpx
, iso8601
, poetry-core
, pydantic_1
, pyjwt
, pytest-asyncio
, pytestCheckHook
, python-dateutil
, pythonAtLeast
, pythonOlder
, pythonRelaxDepsHook
, respx
, retrying
, rfc3339
, toml
}:

buildPythonPackage rec {
  pname = "qcs-api-client";
  version = "0.23.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rigetti";
    repo = "qcs-api-client-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-Z+RCjpSpfYU3oU5HQ8CzZfwqUjMHvCKVn+p2tq+VDxQ=";
  };

  patches = [
    # Switch to poetry-core, https://github.com/rigetti/qcs-api-client-python/pull/2
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/rigetti/qcs-api-client-python/commit/32f0b3c7070a65f4edf5b2552648d88435469e44.patch";
      hash = "sha256-mOc+Q/5cmwPziojtxeEMWWHSDvqvzZlNRbPtOSeTinQ=";
    })
  ];

  pythonRelaxDeps = [
    "attrs"
    "httpx"
    "iso8601"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    attrs
    httpx
    iso8601
    pydantic_1
    pyjwt
    python-dateutil
    retrying
    rfc3339
    toml
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    respx
  ];

  # Tests are failing on Python 3.11, Fatal Python error: Aborted
  doCheck = !(pythonAtLeast "3.11");

  pythonImportsCheck = [
    "qcs_api_client"
  ];

  meta = with lib; {
    description = "Python library for accessing the Rigetti QCS API";
    homepage = "https://qcs-api-client-python.readthedocs.io/";
    changelog = "https://github.com/rigetti/qcs-api-client-python/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
