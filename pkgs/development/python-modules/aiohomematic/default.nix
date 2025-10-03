{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  orjson,
  pydevccu,
  pytest-asyncio,
  pytest-socket,
  pytestCheckHook,
  python-slugify,
  setuptools,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "aiohomematic";
  version = "2025.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SukramJ";
    repo = "aiohomematic";
    tag = version;
    hash = "sha256-6bJh+9giJaxmUB/UHRt/RmtoMYkCJ4ZF01WA2K6NF9Y=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==80.9.0" "setuptools"
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    orjson
    python-slugify
    voluptuous
  ];

  nativeCheckInputs = [
    freezegun
    pydevccu
    pytest-asyncio
    pytest-socket
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiohomematic" ];

  disabledTests = [
    # AssertionError: assert 548 == 555
    "test_central_full"
  ];

  meta = {
    description = "Module to interact with HomeMatic devices";
    homepage = "https://github.com/SukramJ/aiohomematic";
    changelog = "https://github.com/SukramJ/aiohomematic/blob/${src.tag}/changelog.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dotlambda
      fab
    ];
  };
}
