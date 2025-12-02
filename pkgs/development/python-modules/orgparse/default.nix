{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "orgparse";
  version = "0.4.20251020";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "karlicoss";
    repo = "orgparse";
    tag = "v${version}";
    hash = "sha256-RJ+1HVI9OgbylBxdEztpQ4v0MG0PUFqXlFfe0vsDaTg=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "orgparse" ];

  preCheck = ''
    rm conftest.py
  '';

  disabledTestPaths = [
    # Ignoring doc folder
    "doc/"
  ];

  disabledTests = [
    # AssertionError
    "test_data[01_attributes]"
    "test_data[03_repeated_tasks]"
    "test_data[04_logbook]"
    "test_level_0_timestamps"
  ];

  meta = with lib; {
    description = "Emacs org-mode parser in Python";
    homepage = "https://github.com/karlicoss/orgparse";
    changelog = "https://github.com/karlicoss/orgparse/releases/tag/${src.tag}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ twitchy0 ];
  };
}
