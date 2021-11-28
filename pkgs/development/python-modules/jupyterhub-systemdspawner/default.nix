{ lib
, buildPythonPackage
, fetchFromGitHub
, jupyterhub
, tornado
, bash
}:

buildPythonPackage rec {
  pname = "jupyterhub-systemdspawner";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "jupyterhub";
    repo = "systemdspawner";
    # Corresponds to 0.15.0
    # Upstream didn't tag the latest release:
    # https://github.com/jupyterhub/systemdspawner/issues/89
    rev = "7d7cf42db76d9cfa5a4bc42fff14943877ac570b";
    sha256 = "sha256-EUCA+CKCeYr+cLVrqTqe3Q32JkbqeALL6tfOnlVHk8Q=";
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
    maintainers = with maintainers; [ costrouc erictapen ];
  };
}
