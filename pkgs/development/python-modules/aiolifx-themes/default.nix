{ lib
<<<<<<< HEAD
, aiolifx
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
=======
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, aiolifx
, poetry-core
, pytest-asyncio
, pytestCheckHook
, async-timeout
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, typer
}:

buildPythonPackage rec {
  pname = "aiolifx-themes";
<<<<<<< HEAD
  version = "0.4.8";
=======
  version = "0.4.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Djelibeybi";
    repo = "aiolifx-themes";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-jbL6f6gDH6AxsfuD7mFtvCGKLqy/NKoo5bUmXN9hBrM=";
=======
    hash = "sha256-df3FQdOa3C8eQfgFi+sh7+/GBpE+4B5gOI+3XDQLHEs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  prePatch = ''
    # Don't run coverage, or depend on typer for no reason.
    substituteInPlace pyproject.toml \
      --replace " --cov=aiolifx_themes --cov-report=term-missing:skip-covered" "" \
      --replace "typer = " "# unused: typer = "
  '';

<<<<<<< HEAD
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'aiolifx = "^0.8.6"' 'aiolifx = "*"'
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
