{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pandoc,
  installShellFiles,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "autotrash";
  version = "0.4.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bneijt";
    repo = "autotrash";
    rev = "refs/tags/${version}";
    hash = "sha256-qMU3jjBL5+fd9vKX5BIqES5AM8D/54aBOmdHFiBtfEo=";
  };

  build-system = [ poetry-core ];

  nativeBuildInputs = [
    installShellFiles
    pandoc
  ];
  postBuild = "make -C doc autotrash.1";
  postInstall = "installManPage doc/autotrash.1";

  pythonImportsCheck = [ "autotrash" ];
  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Tool to automatically purge old trashed files";
    license = lib.licenses.gpl3Plus;
    homepage = "https://bneijt.nl/pr/autotrash";
    maintainers = with lib.maintainers; [
      sigmanificient
      mithicspirit
    ];
    mainProgram = "autotrash";
  };
}
