{ lib
, buildPythonPackage
, fetchPypi
, autoconf
, cython
, setuptools
}:

buildPythonPackage rec {
  pname = "dtlssocket";
<<<<<<< HEAD
  version = "0.1.16";
=======
  version = "0.1.14";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  format = "pyproject";

  src = fetchPypi {
    pname = "DTLSSocket";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-MLEIrkX84cAz4+9sLd1+dBgGKuN0Io46f6lpslQ2ajk=";
=======
    hash = "sha256-BLNfdKDKUvc+BJnhLqx7VzJg0opvrdaXhNLCigLH02k=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    autoconf
    cython
    setuptools
  ];

  # no tests on PyPI, no tags on GitLab
  doCheck = false;

  pythonImportsCheck = [ "DTLSSocket" ];

  meta = with lib; {
    description = "Cython wrapper for tinydtls with a Socket like interface";
    homepage = "https://git.fslab.de/jkonra2m/tinydtls-cython";
    license = licenses.epl10;
    maintainers = with maintainers; [ dotlambda ];
  };
}
