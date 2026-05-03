{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  certifi,
  loguru,
  typer,
  typing-extensions,
  pytestCheckHook,
  pytest-asyncio,
  pytest-mock,
  mock,
  trustme,
  nix-update-script,
  poetry-core,
  pythonRelaxDepsHook,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiospamc";
  version = "1.2.0";
  pyproject = true;

  __structuredAttrs = true;

  pythonRelaxDeps = [
    "typer"
  ];

  src = fetchFromGitHub {
    owner = "mjcaley";
    repo = "aiospamc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9Y0XR37UOpTSbp34rOhb0b3997BnH8OvSXaCc25nW/E=";
  };

  build-system = [
    uv-build
  ];


  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'uv_build>=0.7.19,<0.8.0' 'uv_build>=0.7.19'
  '';

  dependencies = [
    certifi
    loguru
    typer
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-mock
    mock
    trustme
  ];

  pythonImportsCheck = [ "aiospamc" ];

  disabledTestPaths = [
    "tests/test_cli.py"
  ];


  meta = with lib; {
    description = "An asyncio-based library to communicate with SpamAssassin's SPAMD service";
    longDescription = ''
      Python asyncio-based library that implements the SPAMC/SPAMD client protocol used by SpamAssassin.
      It allows you to ping, check, and report messages to a SpamAssassin server asynchronously.
    '';
    homepage = "https://github.com/mjcaley/aiospamc";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
