{
  lib,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  webcolors,
  pythonOlder,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "flux-led";
  version = "1.1.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "flux_led";
    tag = version;
    hash = "sha256-lFOxf9+O1APreIL/wQTZ+zSMx/MxPTRQrFWgw324myY=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '"pytest-runner>=5.2",' ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    async-timeout
    webcolors
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "tests.py" ];

  pythonImportsCheck = [ "flux_led" ];

  meta = with lib; {
    description = "Python library to communicate with the flux_led smart bulbs";
    homepage = "https://github.com/Danielhiversen/flux_led";
    changelog = "https://github.com/Danielhiversen/flux_led/releases/tag/${version}";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
    mainProgram = "flux_led";
  };
}
