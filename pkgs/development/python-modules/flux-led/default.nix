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
  version = "1.0.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "flux_led";
    rev = "refs/tags/${version}";
    hash = "sha256-enYo2hZ1C8jqO+8xZhSmIOJQAyrtVUJ9S/e2Bxzhv0I=";
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

  disabledTests = [
    # AttributeError: module 'webcolors' has no attribute 'CSS2_HEX_TO_NAMES'
    "test_get_color_names_list"
  ];

  meta = with lib; {
    description = "Python library to communicate with the flux_led smart bulbs";
    homepage = "https://github.com/Danielhiversen/flux_led";
    changelog = "https://github.com/Danielhiversen/flux_led/releases/tag/${version}";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ colemickens ];
    platforms = platforms.linux;
    mainProgram = "flux_led";
  };
}
