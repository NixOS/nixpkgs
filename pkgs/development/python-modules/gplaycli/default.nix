{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  args,
  clint,
  libffi,
  matlink-gpapi,
  ndg-httpsclient,
  protobuf,
  pyasn1,
  pyaxmlparser,
  requests,

  # test
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "gplaycli";
  version = "3.29";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "matlink";
    repo = "gplaycli";
    tag = version;
    hash = "sha256-uZBrIxnDSaJDOPcD7J4SCPr9nvecDDR9h+WnIjIP7IE=";
  };

  build-system = [ setuptools ];

  # the expected protoc is too old, so fall back to the pure python implementation
  preBuild = ''
    export PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=python
  '';

  dependencies = [
    args
    clint
    libffi
    matlink-gpapi
    ndg-httpsclient
    protobuf
    pyasn1
    pyaxmlparser
    requests
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

  meta = {
    description = "Google Play Downloader via Command line";
    mainProgram = "gplaycli";
    homepage = "https://github.com/matlink/gplaycli";
    changelog = "https://github.com/matlink/gplaycli/releases/tag/${src.tag}";
    license = lib.licenses.agpl3Plus;
    maintainers = [ ];
  };
}
