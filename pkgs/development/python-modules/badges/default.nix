{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  colorscript,
  getch,
  prompt-toolkit,
}:

buildPythonPackage (finalAttrs: {
  pname = "badges";
  version = "1.0.0-unstable-2026-01-05";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "EntySec";
    repo = "Badges";
    # https://github.com/EntySec/Badges/issues/6
    rev = "5fdc197864ee9488281cd8d9a64170671ec88dba";
    hash = "sha256-oiG2nx3hZqwMDjCUQYFu6SH9C1ocrZrjOIn2hC8gsVQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    colorscript
    getch
    prompt-toolkit
  ];

  pythonImportsCheck = [ "badges" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Helpers for terminal output, interactive prompts, structured tables and ASCII world map";
    homepage = "https://github.com/EntySec/Badges";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
