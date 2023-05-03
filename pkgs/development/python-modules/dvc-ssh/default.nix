{ lib
, bcrypt
, buildPythonPackage
, fetchPypi
, pythonRelaxDepsHook
, setuptools-scm
, sshfs
}:

buildPythonPackage rec {
  pname = "dvc-ssh";
  version = "2.21.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iew/+/Ww6Uvz6Ctvswd8l5YFa3zihYxo1jvTe0ZTW9M=";
  };

  # Prevent circular dependency
  pythonRemoveDeps = [ "dvc" ];

  nativeBuildInputs = [ setuptools-scm pythonRelaxDepsHook ];

  propagatedBuildInputs = [ bcrypt sshfs ];

  # bcrypt is enabled for sshfs in nixpkgs
  postPatch = ''
    substituteInPlace setup.cfg --replace "sshfs[bcrypt]" "sshfs"
  '';

  # Network access is needed for tests
  doCheck = false;

  pythonCheckImports = [ "dvc_ssh" ];

  meta = with lib; {
    description = "ssh plugin for dvc";
    homepage = "https://pypi.org/project/dvc-ssh/${version}";
    changelog = "https://github.com/iterative/dvc-ssh/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ melling ];
  };
}
