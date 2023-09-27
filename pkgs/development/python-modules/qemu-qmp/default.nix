{ lib
, buildPythonPackage
, fetchFromGitLab
, setuptools
, setuptools-scm
, wheel
}:

buildPythonPackage rec {
  pname = "qemu.qmp";
  version = "0.0.3";
  format = "pyproject";

  src = fetchFromGitLab {
    owner = "qemu-project";
    repo = "python-qemu-qmp";
    rev = "v${version}";
    hash = "sha256-NOtBea81hv+swJyx8Mv2MIqoK4/K5vyMiN12hhDEpJY=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  pythonImportsCheck = [ "qemu.qmp" ];

  meta = with lib; {
    description = "An asyncio library for communicating with QEMU Monitor Protocol (“QMP”) servers";
    homepage = "https://gitlab.com/qemu-project/python-qemu-qmp";
    license = with licenses; [ gpl2Only lgpl2Only ];
    maintainers = with maintainers; [ raitobezarius ];
  };
}
