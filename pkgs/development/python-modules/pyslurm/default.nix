{ lib
, pythonOlder
, fetchFromGitHub
, buildPythonPackage
, cython
, slurm
}:

buildPythonPackage rec {
  pname = "pyslurm";
  version = "23.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    repo = "pyslurm";
    owner = "PySlurm";
    rev = "refs/tags/v${version}";
    hash = "sha256-M8seh5pkw2OTiDU4O96D0Lg3+FrlB2w4ehy53kSxyoU=";
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
