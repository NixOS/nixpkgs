{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  pandoc,
}:

python3Packages.buildPythonApplication rec {
  pname = "systemd-language-server";
  version = "0.3.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "psacawa";
    repo = "systemd-language-server";
    tag = version;
    hash = "sha256-QRd2mV4qRh4OfVJ2/5cOm3Wh8ydsLTG9Twp346DHjs0=";
  };

  build-system = with python3Packages; [
    poetry-core
  ];

  pythonRelaxDeps = [
    "lxml"
  ];
  dependencies = with python3Packages; [
    lxml
    pygls
  ];

  pythonImportsCheck = [ "systemd_language_server" ];

  nativeCheckInputs = [
    pandoc
    python3Packages.pytestCheckHook
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # TimeoutError
    "test_hover"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Language Server for Systemd unit files";
    homepage = "https://github.com/psacawa/systemd-language-server";
    changelog = "https://github.com/psacawa/systemd-language-server/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "systemd-language-server";
  };
}
