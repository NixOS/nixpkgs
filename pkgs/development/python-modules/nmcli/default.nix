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
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ushiboy";
    repo = "nmcli";
    tag = "v${version}";
    hash = "sha256-F8cZvsW51dhE+KBKF0OKCTN0mDKOJBm1CEtn1MAa+gA=";
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
