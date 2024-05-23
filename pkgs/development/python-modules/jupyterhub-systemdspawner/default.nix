{
  lib,
  bash,
  buildPythonPackage,
  fetchFromGitHub,
  jupyterhub,
  pythonOlder,
  tornado,
}:

buildPythonPackage rec {
  pname = "jupyterhub-systemdspawner";
  version = "1.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jupyterhub";
    repo = "systemdspawner";
    rev = "refs/tags/v${version}";
    hash = "sha256-2Pxswa472umovHBUVTIX1l+Glj6bzzgBLsu+p4IA6jA=";
  };

  postPatch = ''
    substituteInPlace systemdspawner/systemd.py \
      --replace "/bin/bash" "${bash}/bin/bash"

    substituteInPlace systemdspawner/systemdspawner.py \
      --replace "/bin/bash" "${bash}/bin/bash"
  '';

  buildInputs = [ bash ];

  propagatedBuildInputs = [
    jupyterhub
    tornado
  ];

  # Module has no tests
  doCheck = false;

  postInstall = ''
    mkdir -p $out/bin
    cp check-kernel.bash $out/bin/
    patchShebangs $out/bin
  '';

  pythonImportsCheck = [ "systemdspawner" ];

  meta = with lib; {
    description = "JupyterHub Spawner using systemd for resource isolation";
    mainProgram = "check-kernel.bash";
    homepage = "https://github.com/jupyterhub/systemdspawner";
    changelog = "https://github.com/jupyterhub/systemdspawner/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
