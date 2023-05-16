{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, aiohttp
, beautifulsoup4
, httpx
, importlib-metadata
, multidict
, typer
, yarl
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "authcaptureproxy";
<<<<<<< HEAD
  version = "1.2.0";
=======
  version = "1.1.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "alandtse";
    repo = "auth_capture_proxy";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-OY6wT0xi7f6Bn8VOL9+6kyv5cENYbrGGTWWKc6o36cw=";
=======
    hash = "sha256-HYqbOyJlP1rd8jpqbN9I4JuVpBKxR9/Nvoh544t40uo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    beautifulsoup4
    httpx
    importlib-metadata
    multidict
    typer
    yarl
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/alandtse/auth_capture_proxy/releases/tag/v${version}";
    description = "A proxy to capture authentication information from a webpage";
    homepage = "https://github.com/alandtse/auth_capture_proxy";
    license = licenses.asl20;
    maintainers = with maintainers; [ graham33 hexa ];
  };
}
