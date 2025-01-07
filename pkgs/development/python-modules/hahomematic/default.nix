{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  orjson,
  pydevccu,
  pytest-aiohttp,
  pytestCheckHook,
  python-slugify,
  pythonOlder,
  setuptools,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "hahomematic";
  version = "2024.12.2";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "danielperna84";
    repo = "hahomematic";
    rev = "refs/tags/${version}";
    hash = "sha256-pQiOi6uJcfeBOPmL9MksHLqnemHD9Qk6e7QTI9J3NCc=";
  };

  __darwinAllowLocalNetworking = true;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==75.6.0" "setuptools" \
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
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [ "hahomematic" ];

  meta = with lib; {
    description = "Python module to interact with HomeMatic devices";
    homepage = "https://github.com/danielperna84/hahomematic";
    changelog = "https://github.com/danielperna84/hahomematic/blob/${src.rev}/changelog.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      dotlambda
      fab
    ];
  };
}
