{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "wa_crypt_tools";
  version = "0.1.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-E/k2lKxlBxUDnfbeELHBi3sML3T+BQJ3zPHh4hGviJ4=";
  };

  nativeBuildInputs = [ python3Packages.setuptools-scm ];

  pythonRelaxDeps = [ "protobuf" ];

  propagatedBuildInputs = with python3Packages; [
    setuptools
    javaobj-py3
    pycryptodomex
    protobuf
  ];

  meta = {
    description = "Manage WhatsApp .crypt12, .crypt14 and .crypt15 files";
    homepage = "https://github.com/ElDavoo/wa-crypt-tools";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ EstebanMacanek ];
    platforms = lib.platforms.all;
  };
}
