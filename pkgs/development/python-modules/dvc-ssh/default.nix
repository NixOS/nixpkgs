{
  lib,
  bcrypt,
  buildPythonPackage,
  dvc-objects,
  fetchPypi,
  setuptools-scm,
  sshfs,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "dvc-ssh";
  version = "4.2.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "dvc_ssh";
    inherit version;
    hash = "sha256-T6yTLF8ivZRE2H1Oez/9bAnMjlbZjrPG1LRDAdNTUBc=";
  };

  pythonRemoveDeps = [
    # Prevent circular dependency
    "dvc"
  ];

  build-system = [ setuptools-scm ];

  dependencies = [
    bcrypt
    dvc-objects
    sshfs
  ];

  optional-dependencies = {
    gssapi = [ sshfs ];
  };

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
    description = "SSH plugin for dvc";
    homepage = "https://pypi.org/project/dvc-ssh/${version}";
    changelog = "https://github.com/iterative/dvc-ssh/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ melling ];
  };
}
