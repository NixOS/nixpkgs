{
  lib,
  pythonOlder,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  cython,
  slurm,
}:

buildPythonPackage rec {
  pname = "pyslurm";
  version = "24.11.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    repo = "pyslurm";
    owner = "PySlurm";
    tag = "v${version}";
    hash = "sha256-Uko4fgi080XWSseOBijzvzi0YtjuRIvH8qSKEWrpFG0=";
  };

  nativeBuildInputs = [ setuptools ];

  buildInputs = [
    cython
    slurm
  ];

  env = {
    SLURM_LIB_DIR = "${lib.getLib slurm}/lib";
    SLURM_INCLUDE_DIR = "${lib.getDev slurm}/include";
  };

  # Test cases need /etc/slurm/slurm.conf and require a working slurm installation
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/PySlurm/pyslurm";
    description = "Python bindings to Slurm";
    license = licenses.gpl2;
    maintainers = with maintainers; [ bhipple ];
    platforms = platforms.linux;
  };
}
