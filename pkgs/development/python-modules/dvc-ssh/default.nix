{
  lib,
  bcrypt,
  buildPythonPackage,
  dvc-objects,
  fetchPypi,
  pythonRelaxDepsHook,
  setuptools-scm,
  sshfs,
}:

buildPythonPackage rec {
  pname = "dvc-ssh";
  version = "4.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lvC6oAXQR4u7s+11n6NgQExPc9yrq3JAmmXtuOw22tI=";
  };

  pythonRemoveDeps = [
    # Prevent circular dependency
    "dvc"
  ];

  nativeBuildInputs = [
    setuptools-scm
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    bcrypt
    dvc-objects
    sshfs
  ];

  # bcrypt is enabled for sshfs in nixpkgs
  postPatch = ''
    substituteInPlace setup.cfg --replace "sshfs[bcrypt]" "sshfs"
  '';

  # Network access is needed for tests
  doCheck = false;

  # Circular dependency
  # pythonImportsCheck = [
  #  "dvc_ssh"
  # ];

  meta = with lib; {
    description = "ssh plugin for dvc";
    homepage = "https://pypi.org/project/dvc-ssh/${version}";
    changelog = "https://github.com/iterative/dvc-ssh/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ melling ];
  };
}
