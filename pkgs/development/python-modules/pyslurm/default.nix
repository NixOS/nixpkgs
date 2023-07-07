{ lib
, pythonOlder
, fetchFromGitHub
, buildPythonPackage
, cython
, slurm
}:

buildPythonPackage rec {
  pname = "pyslurm";
  version = "23.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    repo = "pyslurm";
    owner = "PySlurm";
    rev = "refs/tags/v${version}";
    hash = "sha256-EYXVkQGe5A+fmzcBdhMnALzX8k7hxaCYsL1Ehrikme4=";
  };

  buildInputs = [ cython slurm ];

  setupPyBuildFlags = [ "--slurm-lib=${slurm}/lib" "--slurm-inc=${slurm.dev}/include" ];

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
