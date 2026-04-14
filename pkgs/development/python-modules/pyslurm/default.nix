{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  cython,
  slurm,
}:

buildPythonPackage rec {
  pname = "pyslurm";
  version = "25.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "pyslurm";
    owner = "PySlurm";
    tag = "v${version}";
    hash = "sha256-t6otxWBxu4mxTZpIS+lhlcXf4bOaxNgeDmW6BCNTclc=";
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

  meta = {
    homepage = "https://github.com/PySlurm/pyslurm";
    description = "Python bindings to Slurm";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
