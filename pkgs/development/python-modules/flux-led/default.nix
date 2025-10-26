{
  lib,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  webcolors,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "flux-led";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "flux_led";
    tag = version;
    hash = "sha256-+i+/WMHdz4HPKDlRPV1Aq9QqrTo5gZiulSc7Hinn+kI=";
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

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "flux_led" ];

  meta = {
    description = "Python library to communicate with the flux_led smart bulbs";
    homepage = "https://github.com/Danielhiversen/flux_led";
    changelog = "https://github.com/Danielhiversen/flux_led/releases/tag/${version}";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "flux_led";
  };
}
