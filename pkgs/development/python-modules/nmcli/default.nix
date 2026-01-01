{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  setuptools,
  wheel,
  networkmanager,
}:

buildPythonPackage rec {
  pname = "nmcli";
<<<<<<< HEAD
  version = "1.6.0";
=======
  version = "1.5.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ushiboy";
    repo = "nmcli";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-F8cZvsW51dhE+KBKF0OKCTN0mDKOJBm1CEtn1MAa+gA=";
=======
    hash = "sha256-1gVj4WfTx1NcoyWA9OK5EyGze9hmrXV0Mq50C1S3bfM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    setuptools
    wheel
  ];

  patches = [
    (replaceVars ./nmcli-path.patch {
      nmcli = lib.getExe' networkmanager "nmcli";
    })
  ];

  meta = {
    description = "Python library for interacting with NetworkManager CLI";
    homepage = "https://github.com/ushiboy/nmcli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ktechmidas ];
    inherit (networkmanager.meta) platforms;
    changelog = "https://github.com/ushiboy/nmcli/releases/tag/v${version}";
  };
}
