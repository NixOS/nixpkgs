{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  btrfs-progs,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "btrsync";
  version = "0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "andreittr";
    repo = "btrsync";
    tag = "v${version}";
    hash = "sha256-1LpHO70Yli9VG1UeqPZWM2qUMUbSbdgNP/r7FhUY/h4=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [ btrfs-progs ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "btrsync" ];

  meta = {
    description = "Btrfs replication made easy";
    homepage = "https://github.com/andreittr/btrsync";
    changelog = "https://github.com/andreittr/btrsync/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    mainProgram = "btrsync";
    maintainers = with lib.maintainers; [ bcyran ];
  };
}
