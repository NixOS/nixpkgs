{
  lib,
  aiolifx,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "aiolifx-themes";
  version = "0.5.8";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Djelibeybi";
    repo = "aiolifx-themes";
    rev = "refs/tags/v${version}";
    hash = "sha256-MeGhtjdvtL0armoLrlqPsV4SUCTWbkBvRTj6ReuKQpQ=";
  };

  build-system = [ poetry-core ];

  dependencies = [ aiolifx ];

  nativeCheckInputs = [
    async-timeout
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "aiolifx_themes" ];

  meta = with lib; {
    description = "Color themes for LIFX lights running on aiolifx";
    homepage = "https://github.com/Djelibeybi/aiolifx-themes";
    changelog = "https://github.com/Djelibeybi/aiolifx-themes/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ lukegb ];
  };
}
