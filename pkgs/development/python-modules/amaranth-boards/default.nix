{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  amaranth,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "amaranth-boards";
  version = "0-unstable-2023-12-13";
  pyproject = true;
  # python setup.py --version
  realVersion = "0.1.dev202+g${lib.substring 0 7 src.rev}";

  src = fetchFromGitHub {
    owner = "amaranth-lang";
    repo = "amaranth-boards";
    rev = "170675812b71ee722bcf8ccdb88409a9ad97ffe2";
    hash = "sha256-dwZCKMJnEY9RjzkcJ9r3TEC7W+Wfi/P7Hjl4/d60/qo=";
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

  meta = with lib; {
    description = "Board definitions for Amaranth HDL";
    homepage = "https://github.com/amaranth-lang/amaranth-boards";
    license = licenses.bsd2;
    maintainers = with maintainers; [
      emily
      thoughtpolice
      pbsds
    ];
  };
}
