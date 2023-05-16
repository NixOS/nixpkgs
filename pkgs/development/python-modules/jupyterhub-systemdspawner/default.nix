{ lib
<<<<<<< HEAD
, bash
, buildPythonPackage
, fetchFromGitHub
, jupyterhub
, pythonOlder
, tornado
=======
, buildPythonPackage
, fetchFromGitHub
, jupyterhub
, tornado
, bash
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "jupyterhub-systemdspawner";
<<<<<<< HEAD
  version = "1.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";
=======
  version = "0.15";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jupyterhub";
    repo = "systemdspawner";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-2Pxswa472umovHBUVTIX1l+Glj6bzzgBLsu+p4IA6jA=";
  };

=======
    rev = "v${version}";
    hash = "sha256-EUCA+CKCeYr+cLVrqTqe3Q32JkbqeALL6tfOnlVHk8Q=";
  };

  propagatedBuildInputs = [
    jupyterhub
    tornado
  ];

  buildInputs = [ bash ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postPatch = ''
    substituteInPlace systemdspawner/systemd.py \
      --replace "/bin/bash" "${bash}/bin/bash"

    substituteInPlace systemdspawner/systemdspawner.py \
      --replace "/bin/bash" "${bash}/bin/bash"
  '';

<<<<<<< HEAD
  buildInputs = [
    bash
  ];

  propagatedBuildInputs = [
    jupyterhub
    tornado
  ];

  # Module has no tests
=======
  # no tests
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  doCheck = false;

  postInstall = ''
    mkdir -p $out/bin
    cp check-kernel.bash $out/bin/
    patchShebangs $out/bin
  '';

<<<<<<< HEAD
  pythonImportsCheck = [
    "systemdspawner"
  ];

  meta = with lib; {
    description = "JupyterHub Spawner using systemd for resource isolation";
    homepage = "https://github.com/jupyterhub/systemdspawner";
    changelog = "https://github.com/jupyterhub/systemdspawner/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
=======
  meta = with lib; {
    description = "JupyterHub Spawner using systemd for resource isolation";
    homepage = "https://github.com/jupyterhub/systemdspawner";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
