{ lib
, pythonOlder
, fetchFromGitHub
, buildPythonPackage
, cython
, slurm
}:

buildPythonPackage rec {
  pname = "pyslurm";
<<<<<<< HEAD
  version = "23.2.2";
=======
  version = "22.5.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    repo = "pyslurm";
    owner = "PySlurm";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-M8seh5pkw2OTiDU4O96D0Lg3+FrlB2w4ehy53kSxyoU=";
=======
    hash = "sha256-sPZELCxe2e7/gUmRxvP2aOwqsbaR/x+0grHwuDdx0Dg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
