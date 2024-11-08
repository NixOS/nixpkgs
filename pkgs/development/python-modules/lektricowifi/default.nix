{
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  lib,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "lektricowifi";
  version = "0.0.43";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Lektrico";
    repo = "lektricowifi";
    rev = "refs/tags/v.${version}";
    hash = "sha256-NwM1WpH6tS0iAVpG2gSFJpDPPn9nECHAzpOnWzeYPH4=";
  };

  postPatch = ''
    substituteInPlace tests/test_mocked_devices.py \
      --replace-fail "from asyncmock import AsyncMock" "from unittest.mock import AsyncMock"
  '';

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "pydantic"
  ];

  dependencies = [
    async-timeout
    httpx
    pydantic
  ];

  pythonImportsCheck = [ "lektricowifi" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  # AttributeError: type object 'InfoForCharger' has no attribute 'from_dict'
  doCheck = false;

  meta = {
    description = "Communication with Lektrico's chargers";
    homepage = "https://github.com/Lektrico/lektricowifi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
