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
    # webcolors API change, https://github.com/Danielhiversen/flux_led/issues/401
    substituteInPlace flux_led/utils.py \
      --replace-fail "CSS2_HEX_TO_NAMES.values()" 'names("css2")' \
      --replace-fail "CSS21_HEX_TO_NAMES.values()" 'names("css21")' \
      --replace-fail "CSS3_HEX_TO_NAMES.values()" 'names("css3")' \
      --replace-fail "HTML4_HEX_TO_NAMES.values()" 'names("html4")'
  '';

  build-system = [ setuptools ];

  dependencies = [
    async-timeout
    webcolors
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "tests.py" ];

  pythonImportsCheck = [ "flux_led" ];

  # disabledTests = [
  #   # AttributeError: module 'webcolors' has no attribute 'CSS2_HEX_TO_NAMES'
  #   "test_get_color_names_list"
  # ];

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
