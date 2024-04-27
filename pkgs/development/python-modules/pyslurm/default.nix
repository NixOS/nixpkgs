{ lib
, pythonOlder
, fetchFromGitHub
, fetchpatch
, buildPythonPackage
, cython
, slurm
}:

buildPythonPackage rec {
  pname = "pyslurm";
  version = "23.11.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    repo = "pyslurm";
    owner = "PySlurm";
    rev = "refs/tags/v${version}";
    hash = "sha256-Qi0XftneKj7hdDiLY2hoRONRrPv49mfQlvlNkudH54Y=";
  };

  patches = [ (fetchpatch {
    name = "remove-undeclared-KILL_JOB_ARRAY";
    url = "https://github.com/PySlurm/pyslurm/commit/f7a7d8beb8ceb4e4c1b248bab2ebb995dcae77e2.patch";
    hash = "sha256-kQLGiGzAhqP8Z6pObz9vdTRdITd12w7KuUDXsfyLIU8=";
  })];

  buildInputs = [ cython slurm ];

  setupPyBuildFlags = [ "--slurm-lib=${lib.getLib slurm}/lib" "--slurm-inc=${lib.getDev slurm}/include" ];

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
