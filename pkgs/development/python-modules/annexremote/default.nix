{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "annexremote";
  version = "1.6.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Lykos153";
    repo = "AnnexRemote";
    rev = "refs/tags/v${version}";
    hash = "sha256-8WAa5EO5n/dccNW0TUwFgcRjvDFt8QfpHIX2arM4HGc=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "annexremote" ];

  meta = with lib; {
    description = "Helper module to easily develop git-annex remotes";
    homepage = "https://github.com/Lykos153/AnnexRemote";
    changelog = "https://github.com/Lykos153/AnnexRemote/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ montag451 ];
  };
}
