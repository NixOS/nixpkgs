{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  networkmanager,
}:

buildPythonPackage rec {
  pname = "nmcli";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ushiboy";
    repo = "nmcli";
    tag = "v${version}";
    hash = "sha256-1gVj4WfTx1NcoyWA9OK5EyGze9hmrXV0Mq50C1S3bfM=";
  };

  build-system = [
    setuptools
    wheel
  ];

  postPatch = ''
    substituteInPlace nmcli/_system.py \
    --replace-fail "c = ['sudo', 'nmcli'] if self._use_sudo else ['nmcli']" \
                   "c = ['sudo', '${lib.getExe' networkmanager "nmcli"}'] if self._use_sudo else ['${lib.getExe' networkmanager "nmcli"}']"
  '';

  meta = {
    description = "Python library for interacting with NetworkManager CLI";
    homepage = "https://github.com/ushiboy/nmcli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ktechmidas ];
    mainProgram = "nmcli";
    inherit (networkmanager.meta) platforms;
    changelog = "https://github.com/ushiboy/nmcli/releases/tag/v${version}";
  };
}
