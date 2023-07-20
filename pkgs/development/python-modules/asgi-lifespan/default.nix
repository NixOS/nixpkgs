{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  pytestCheckHook,
  nix-update-script,
  starlette,
  httpx,
  pytest-asyncio,
  pytest-trio,
  pytest-cov,
}:
buildPythonPackage rec {
  version = "2.1.0";
  pname = "asgi-lifespan";
  disabled = pythonOlder "3.7";

  # PyPI tarball doesn't include tests directory
  src = fetchFromGitHub {
    owner = "florimondmanca";
    repo = "asgi-lifespan";
    rev = version;
    hash = "sha256-Jgmd/4c1lxHM/qi3MJNN1aSSUJrI7CRNwwHrFwwcCkc=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    httpx
    pytest-cov
    pytest-asyncio
    pytest-trio
    starlette
  ];

  pytestFlagsArray = [
    "tests/"
    "--no-cov"
  ];

  pythonImportsCheck = ["asgi_lifespan"];

  passthru.updateScript = nix-update-script {};

  meta = with lib; {
    description = "Programmatic startup/shutdown of ASGI apps";
    license = licenses.mit;
    homepage = "https://github.com/florimondmanca/asgi-lifespan";
    maintainers = with maintainers; [emattiza];
  };
}
