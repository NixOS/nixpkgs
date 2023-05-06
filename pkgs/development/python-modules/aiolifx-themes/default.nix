{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, aiolifx
, poetry-core
, pytest-asyncio
, pytestCheckHook
, async-timeout
, typer
}:

buildPythonPackage rec {
  pname = "aiolifx-themes";
  version = "0.4.5";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Djelibeybi";
    repo = "aiolifx-themes";
    rev = "refs/tags/v${version}";
    hash = "sha256-df3FQdOa3C8eQfgFi+sh7+/GBpE+4B5gOI+3XDQLHEs=";
  };

  prePatch = ''
    # Don't run coverage, or depend on typer for no reason.
    substituteInPlace pyproject.toml \
      --replace " --cov=aiolifx_themes --cov-report=term-missing:skip-covered" "" \
      --replace "typer = " "# unused: typer = "
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiolifx
  ];

  nativeCheckInputs = [
    async-timeout
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [
    "aiolifx_themes"
  ];

  meta = with lib; {
    description = "Color themes for LIFX lights running on aiolifx";
    homepage = "https://github.com/Djelibeybi/aiolifx-themes";
    changelog = "https://github.com/Djelibeybi/aiolifx-themes/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ lukegb ];
  };
}
