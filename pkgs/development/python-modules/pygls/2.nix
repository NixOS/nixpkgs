{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  attrs,
  cattrs,
  lsprotocol,
  websockets,
  pytest-asyncio,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "pygls";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openlawlibrary";
    repo = "pygls";
    tag = "v${version}";
    hash = "sha256-dQLK18EACiN+DpWp81Vgaan0mwtifhrmH4xwkqttKvg=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    attrs
    cattrs
    lsprotocol
  ];

  optional-dependencies = {
    ws = [ websockets ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  # Fixes hanging tests on Darwin
  __darwinAllowLocalNetworking = true;

  preCheck = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Darwin issue: OSError: [Errno 24] Too many open files
    ulimit -n 1024
  '';

  pythonImportsCheck = [ "pygls" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      # Skips pre-releases
      "--version-regex"
      "^v([0-9.]+)$"
    ];
  };

  meta = {
    description = "Pythonic generic implementation of the Language Server Protocol";
    homepage = "https://github.com/openlawlibrary/pygls";
    changelog = "https://github.com/openlawlibrary/pygls/blob/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kira-bruneau ];
  };
}
