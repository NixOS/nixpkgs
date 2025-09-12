{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "qemu-qmp";
  version = "0.0.3";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "qemu-project";
    repo = "python-qemu-qmp";
    tag = "v${version}";
    hash = "sha256-NOtBea81hv+swJyx8Mv2MIqoK4/K5vyMiN12hhDEpJY=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonImportsCheck = [ "qemu.qmp" ];

  meta = {
    description = "Asyncio library for communicating with QEMU Monitor Protocol (“QMP”) servers";
    # no changelog, included in the README of the homepage
    homepage = "https://gitlab.com/qemu-project/python-qemu-qmp";
    license = with lib.licenses; [
      lgpl2Plus
      gpl2Only
    ];

    maintainers = with lib.maintainers; [ brianmcgillion ];
  };
}
