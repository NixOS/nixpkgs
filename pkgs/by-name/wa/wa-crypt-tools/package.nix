{
  python3Packages,
  lib,
  versionCheckHook,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "wa-crypt-tools";
  version = "0.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "wa_crypt_tools";
    inherit version;
    hash = "sha256-E/k2lKxlBxUDnfbeELHBi3sML3T+BQJ3zPHh4hGviJ4=";
  };

  build-system = [
    python3Packages.setuptools-scm
  ];

  dependencies = [
    python3Packages.javaobj-py3
    python3Packages.pycryptodomex
    python3Packages.protobuf5
  ];

  # The program does not provide a --version flag.
  dontVersionCheck = true;

  pythonRelaxDeps = [ "protobuf" ];

  meta = {
    description = "Manage WhatsApp .crypt12, .crypt14 and .crypt15 files";
    mainProgram = "wadecrypt";
    homepage = "https://github.com/ElDavoo/wa-crypt-tools";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ kmein ];
  };
}
