{
  lib,
  aiolifx,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  typer,
}:

buildPythonPackage rec {
  pname = "aiolifx-themes";
  version = "0.4.18";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Djelibeybi";
    repo = "aiolifx-themes";
    rev = "refs/tags/v${version}";
    hash = "sha256-6oV6pyVwSS6sYrTokcJ/1KBkuv7EHNr+2bJ5ujengTY=";
  };

  prePatch = ''
    # Don't run coverage, or depend on typer for no reason.
    substituteInPlace pyproject.toml \
      --replace-fail " --cov=aiolifx_themes --cov-report=term-missing:skip-covered" "" \
      --replace-fail "typer = " "# unused: typer = "
  '';

  build-system = [ poetry-core ];

  dependencies = [ aiolifx ];

  nativeCheckInputs = [
    async-timeout
    pytestCheckHook
    pytest-asyncio
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
