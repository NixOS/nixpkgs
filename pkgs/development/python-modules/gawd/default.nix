{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  ruamel-yaml,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "gawd";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pooya-rostami";
    repo = "gawd";
    rev = version;
    hash = "sha256-DCcU7vO5VApRsO+ljVs827TrHIfe3R+1/2wgBEcp1+c=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [ ruamel-yaml ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "gawd" ];

  meta = {
    changelog = "https://github.com/pooya-rostami/gawd/releases/tag/${version}";
    description = "Gawd is a Python library and command-line tool for computing syntactic differences between two GitHub Actions workflow files";
    mainProgram = "gawd";
    homepage = "https://github.com/pooya-rostami/gawd";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
