{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  libffi,
  matlink-gpapi,
  ndg-httpsclient,
  protobuf,
  pyasn1,
  pyaxmlparser,
  pytestCheckHook,
  pythonOlder,
  requests,
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

  propagatedBuildInputs = [
    libffi
    pyasn1
    ndg-httpsclient
    protobuf
    requests
    matlink-gpapi
    pyaxmlparser
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "gplaycli" ];

  preCheck = ''
    export PATH="$PATH:$out/bin";
  '';

  disabledTests = [
    "test_alter_token"
    "test_another_device"
    "test_connection_credentials"
    "test_connection_token"
    "test_download_additional_files"
    "test_download_focus"
    "test_download_version"
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
