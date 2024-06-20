{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  amaranth,
  setuptools,
  setuptools-scm,
  unstableGitUpdater,
}:

buildPythonPackage rec {
  pname = "amaranth-boards";
  version = "0-unstable-2024-05-01";
  pyproject = true;
  # python setup.py --version
  realVersion = "0.1.dev202+g${lib.substring 0 7 src.rev}";

  src = fetchFromGitHub {
    owner = "amaranth-lang";
    repo = "amaranth-boards";
    rev = "aba2300dc83216523e1c98fdb22471cb4bac5027";
    hash = "sha256-IMhNMkOf6dg4Djyi39TDTpU0S3TQM1+e6TBoyiITaos=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];
  dependencies = [
    setuptools
    amaranth
  ];

  preBuild = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION="${realVersion}"
  '';

  # no tests
  doCheck = false;

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Board definitions for Amaranth HDL";
    homepage = "https://github.com/amaranth-lang/amaranth-boards";
    license = licenses.bsd2;
    maintainers = with maintainers; [
      thoughtpolice
      pbsds
    ];
  };
}
