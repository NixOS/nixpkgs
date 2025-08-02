{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "wa-crypt-tools";
  version = "0.1.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "ElDavoo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-v5OrpYCajXNlfdTm569o8qw6REtPSUC9FLLwwDk+L/E=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  pythonRelaxDeps = [ "protobuf" ];

  dependencies = with python3Packages; [
    javaobj-py3
    pycryptodomex
    protobuf
  ];

  nativeCheckInputs = [ python3Packages.pytest ];

  checkPhase = ''
    runHook preCheck
    pytest
    runHook postCheck
  '';

  meta = {
    description = "Manage WhatsApp .crypt12, .crypt14 and .crypt15 files.";
    homepage = "https://github.com/ElDavoo/wa-crypt-tools";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ EstebanMacanek ];
    platforms = lib.platforms.all;
  };
}
