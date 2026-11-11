{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  cython,
  slurm,
}:

buildPythonPackage {
  pname = "pyslurm";
  version = "25.11.2-unstable-2026-11-02";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "pyslurm";
    owner = "PySlurm";
    #tag = "v${version}";
    # https://github.com/PySlurm/pyslurm/pull/427
    rev = "9d9a80365d158021d4dc87cbdc4ead7ecfbbec55";
    hash = "sha256-zHPO/WqnqUA8iBc+J+uJxf+wzpDKzHf8AEd+9jiXS74=";
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
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
}
