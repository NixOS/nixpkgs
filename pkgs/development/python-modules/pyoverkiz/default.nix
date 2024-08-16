{
  lib,
  aiohttp,
  attrs,
  backoff,
  backports-strenum,
  boto3,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  poetry-core,
  pyhumps,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  warrant-lite,
}:

buildPythonPackage rec {
  pname = "pyoverkiz";
  version = "1.13.14";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "iMicknl";
    repo = "python-overkiz-api";
    rev = "refs/tags/v${version}";
    hash = "sha256-HlDydPreHe/O+fqVwjkwQlQx0o9UxI/fwA+idB02Gng=";
  };

  patches = [
    # https://github.com/iMicknl/python-overkiz-api/pull/1309
    (fetchpatch2 {
      url = "https://github.com/iMicknl/python-overkiz-api/commit/9e5bbec3fc88faac9dae0c0c001ed7582c4933e2.patch";
      excludes = [ "poetry.lock" ];
      hash = "sha256-KzagDvljkKoUJT+41o7Jv5OPLpPXQDeGmz3O/HOk1YQ=";
    })
    # https://github.com/iMicknl/python-overkiz-api/pull/1326
    (fetchpatch2 {
      name = "aiohttp-3.10-compat.patch";
      url = "https://github.com/iMicknl/python-overkiz-api/commit/f745c0a9cd654579135624aa472723f85d301aed.patch";
      hash = "sha256-FXyWLnbu0Kqe/dWrWdi4cvyttDQqexhHo0nTumfUo4g=";
    })
  ];

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    attrs
    backoff
    boto3
    pyhumps
    warrant-lite
  ] ++ lib.optionals (pythonOlder "3.11") [ backports-strenum ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyoverkiz" ];

  meta = with lib; {
    description = "Module to interact with the Somfy TaHoma API or other OverKiz APIs";
    homepage = "https://github.com/iMicknl/python-overkiz-api";
    changelog = "https://github.com/iMicknl/python-overkiz-api/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
