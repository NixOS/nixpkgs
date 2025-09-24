{
  lib,
  adb-shell,
  aiofiles,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  pure-python-adb,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "androidtv";
  version = "0.0.75";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "JeffLIrion";
    repo = "python-androidtv";
    tag = "v${version}";
    hash = "sha256-2WFfGGEZkM3fWyTo5P6H3ha04Qyx2OiYetlGWv0jXac=";
  };

  build-system = [ setuptools ];

  dependencies = [
    adb-shell
    async-timeout
    pure-python-adb
  ];

  optional-dependencies = {
    async = [ aiofiles ];
    inherit (adb-shell.optional-dependencies) usb;
  };

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ]
  ++ optional-dependencies.async
  ++ optional-dependencies.usb;

  disabledTests = [
    # Requires git but fails anyway
    "test_no_underscores"
  ];

  pythonImportsCheck = [ "androidtv" ];

  meta = with lib; {
    description = "Communicate with an Android TV or Fire TV device via ADB over a network";
    homepage = "https://github.com/JeffLIrion/python-androidtv/";
    license = licenses.mit;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
