{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  httpx,
  pytest-asyncio,
  pytest-httpx,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "luftdaten";
  version = "0.7.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "python-luftdaten";
    rev = version;
    hash = "sha256-nOhJKlUJ678DJ/ilyRHaiQ2fGfoCl+x6l9lsczVLAGw=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ httpx ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-httpx
    pytestCheckHook
  ];

  pythonImportsCheck = [ "luftdaten" ];

  meta = {
    description = "Python API for interacting with luftdaten.info";
    homepage = "https://github.com/home-assistant-ecosystem/python-luftdaten";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dotlambda
      fab
    ];
  };
}
