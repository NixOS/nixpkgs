{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, freezegun
, orjson
, pydevccu
, pytest-aiohttp
, pytestCheckHook
, python-slugify
, pythonOlder
, setuptools
, voluptuous
, websocket-client
, xmltodict
, wheel
}:

buildPythonPackage rec {
  pname = "hahomematic";
  version = "2024.3.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "danielperna84";
    repo = "hahomematic";
    rev = "refs/tags/${version}";
    hash = "sha256-zSGzdj51StlLMmFZzprQUn6Ry9ahJPUq/Z9hVlKn8oA=";
  };

  patches = [
    # Update pydevccu, extend ruff usage
    # https://github.com/danielperna84/hahomematic/pull/1454
    (fetchpatch {
      url = "https://github.com/danielperna84/hahomematic/commit/81a9a1c9291e2271ac0b995e7dd4725cfe99c7fe.patch";
      includes = [ "tests/test_central_pydevccu.py" ];
      hash = "sha256-l/wNK0/nOZHyrFp+in3ozmMyN5ifo514esGPJVZlb1g=";
    })
  ];

  __darwinAllowLocalNetworking = true;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools~=69.1.0" "setuptools" \
      --replace-fail "wheel~=0.42.0" "wheel"
  '';

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    aiohttp
    orjson
    python-slugify
    voluptuous
  ];

  nativeCheckInputs = [
    freezegun
    pydevccu
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "hahomematic"
  ];

  meta = with lib; {
    description = "Python module to interact with HomeMatic devices";
    homepage = "https://github.com/danielperna84/hahomematic";
    changelog = "https://github.com/danielperna84/hahomematic/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
