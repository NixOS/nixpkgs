{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  charset-normalizer,
}:

buildPythonPackage rec {
  pname = "aeidon";
  version = "1.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "otsaloma";
    repo = "gaupol";
    tag = version;
    hash = "sha256-lhNyeieeiBBm3rNDEU0BuWKeM6XYlOtv1voW8tR8cUM=";
  };

  postPatch = ''
    mv setup.py setup_gaupol.py
    substituteInPlace setup-aeidon.py \
      --replace "from setup import" "from setup_gaupol import"
    mv setup-aeidon.py setup.py
  '';

  build-system = [ setuptools ];

  dependencies = [ charset-normalizer ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "aeidon/test" ];

  disabledTests = [
    # requires gspell to work with gobject introspection
    "test_spell"
  ];

  pythonImportsCheck = [ "aeidon" ];

  meta = with lib; {
    changelog = "https://github.com/otsaloma/gaupol/releases/tag/${version}";
    description = "Reading, writing and manipulationg text-based subtitle files";
    homepage = "https://github.com/otsaloma/gaupol";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ erictapen ];
  };

}
