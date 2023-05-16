{ lib
, bcrypt
, buildPythonPackage
<<<<<<< HEAD
, dvc-objects
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchPypi
, pythonRelaxDepsHook
, setuptools-scm
, sshfs
}:

buildPythonPackage rec {
  pname = "dvc-ssh";
<<<<<<< HEAD
  version = "2.22.2";
=======
  version = "2.22.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-eJwNCZvdBqYKEbX4On3pGm2bzCvH9G7rdsgeN7XPJB0=";
=======
    hash = "sha256-WHFfq0Cw17AWgmUlkZUOO6t6XcPYjLHUz4s0wcVYklc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # Prevent circular dependency
  pythonRemoveDeps = [ "dvc" ];

  nativeBuildInputs = [ setuptools-scm pythonRelaxDepsHook ];

<<<<<<< HEAD
  propagatedBuildInputs = [ bcrypt dvc-objects sshfs ];
=======
  propagatedBuildInputs = [ bcrypt sshfs ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # bcrypt is enabled for sshfs in nixpkgs
  postPatch = ''
    substituteInPlace setup.cfg --replace "sshfs[bcrypt]" "sshfs"
  '';

  # Network access is needed for tests
  doCheck = false;

<<<<<<< HEAD
  pythonImportsCheck = [ "dvc_ssh" ];
=======
  pythonCheckImports = [ "dvc_ssh" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "ssh plugin for dvc";
    homepage = "https://pypi.org/project/dvc-ssh/${version}";
    changelog = "https://github.com/iterative/dvc-ssh/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ melling ];
  };
}
