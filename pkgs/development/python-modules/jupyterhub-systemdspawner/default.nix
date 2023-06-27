{ lib
, buildPythonPackage
, fetchFromGitHub
, jupyterhub
, tornado
, bash
}:

buildPythonPackage rec {
  pname = "jupyterhub-systemdspawner";
  version = "0.15";

  src = fetchFromGitHub {
    owner = "jupyterhub";
    repo = "systemdspawner";
    rev = "v${version}";
    hash = "sha256-EUCA+CKCeYr+cLVrqTqe3Q32JkbqeALL6tfOnlVHk8Q=";
  };

  propagatedBuildInputs = [
    jupyterhub
    tornado
  ];

  buildInputs = [ bash ];

  postPatch = ''
    substituteInPlace systemdspawner/systemd.py \
      --replace "/bin/bash" "${bash}/bin/bash"

    substituteInPlace systemdspawner/systemdspawner.py \
      --replace "/bin/bash" "${bash}/bin/bash"
  '';

  # no tests
  doCheck = false;

  postInstall = ''
    mkdir -p $out/bin
    cp check-kernel.bash $out/bin/
    patchShebangs $out/bin
  '';

  meta = with lib; {
    description = "JupyterHub Spawner using systemd for resource isolation";
    homepage = "https://github.com/jupyterhub/systemdspawner";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
