{ lib
, bcrypt
, buildPythonPackage
, dvc-objects
, fetchPypi
, pythonRelaxDepsHook
, setuptools-scm
, sshfs
}:

buildPythonPackage rec {
  pname = "dvc-ssh";
  version = "2.22.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eJwNCZvdBqYKEbX4On3pGm2bzCvH9G7rdsgeN7XPJB0=";
  };

  # Prevent circular dependency
  pythonRemoveDeps = [ "dvc" ];

  nativeBuildInputs = [ setuptools-scm pythonRelaxDepsHook ];

  propagatedBuildInputs = [ bcrypt dvc-objects sshfs ];

  # bcrypt is enabled for sshfs in nixpkgs
  postPatch = ''
    substituteInPlace setup.cfg --replace "sshfs[bcrypt]" "sshfs"
  '';

  # Network access is needed for tests
  doCheck = false;

  pythonImportsCheck = [ "dvc_ssh" ];

  meta = with lib; {
    description = "ssh plugin for dvc";
    homepage = "https://pypi.org/project/dvc-ssh/${version}";
    changelog = "https://github.com/iterative/dvc-ssh/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ melling ];
  };
}
