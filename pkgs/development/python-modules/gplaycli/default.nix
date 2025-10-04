{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  matlink-gpapi,
  pyaxmlparser,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "gplaycli";
  version = "3.29";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "matlink";
    repo = "gplaycli";
    tag = version;
    hash = "sha256-uZBrIxnDSaJDOPcD7J4SCPr9nvecDDR9h+WnIjIP7IE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    matlink-gpapi
    pyaxmlparser
    setuptools # require pkg_resources
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "gplaycli" ];

  preCheck = ''
    export PATH="$PATH:$out/bin";
  '';

  disabledTests = [
    "test_alter_token"
    "test_another_device"
    "test_connection"
    "test_download"
    "test_search"
    "test_update"
  ];

  meta = with lib; {
    description = "Google Play Downloader via Command line";
    mainProgram = "gplaycli";
    homepage = "https://github.com/matlink/gplaycli";
    changelog = "https://github.com/matlink/gplaycli/releases/tag/${version}";
    license = licenses.agpl3Plus;
    maintainers = [ ];
  };
}
