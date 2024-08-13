{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  construct,
  esptool,
  pygdbmi,
}:

buildPythonPackage rec {
  pname = "esp-coredump";
  version = "1.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "espressif";
    repo = "esp-coredump";
    rev = "v${version}";
    hash = "sha256-yrt/45+vF0YY3D0fK71R/g4Bg2/Qi8SaxbC3Ztkxobo=";
  };

  patches = [
    # This was merged upstream and can be removed on next release
    (fetchpatch {
      name = "replace-distutils-with-shutil.patch";
      url = "https://github.com/espressif/esp-coredump/pull/10/commits/d45c2e7fa98e771d9b22e6fc74e6e5d32dab20a7.patch";
      hash = "sha256-/ufaBFX0Dr+7liz/QxO1NKQNUpZZagVVwx45OkV1W0Q=";
    })
  ];

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    construct
    esptool
    pygdbmi
  ];

  pythonImportsCheck = [ "esp_coredump" ];

  meta = {
    description = "help users to retrieve and analyse core dumps";
    homepage = "https://github.com/espressif/esp-coredump";
    changelog = "https://github.com/espressif/esp-coredump/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "esp-coredump";
  };
}
