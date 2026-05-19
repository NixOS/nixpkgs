{
  lib,
  bash,
  buildPythonPackage,
  fetchFromGitHub,
  jupyterhub,
  setuptools,
  tornado,
}:

buildPythonPackage rec {
  pname = "jupyterhub-systemdspawner";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyterhub";
    repo = "systemdspawner";
    tag = "v${version}";
    hash = "sha256-obM8HGCHsisRV1+kHMWdA7d6eb6awwPMBuDUAf3k0uI=";
  };

  postPatch = ''
    substituteInPlace systemdspawner/systemdspawner.py \
      --replace-fail "/bin/bash" "${bash}/bin/bash"
  '';

  build-system = [ setuptools ];

  dependencies = [
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

  meta = {
    description = "JupyterHub Spawner using systemd for resource isolation";
    mainProgram = "check-kernel.bash";
    homepage = "https://github.com/jupyterhub/systemdspawner";
    changelog = "https://github.com/jupyterhub/systemdspawner/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
