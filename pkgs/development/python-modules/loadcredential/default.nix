{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "loadcredential";
  version = "1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Tom-Hubrecht";
    repo = "loadcredential";
    rev = "v${version}";
    hash = "sha256-GXpMqGLDmDnTGa9cBYe0CP3Evm5sQ3AK9u6k3mLAW34=";
  };

  build-system = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "loadcredential" ];

  meta = {
    description = "Simple python package to read credentials passed through systemd's LoadCredential, with a fallback on env variables ";
    homepage = "https://github.com/Tom-Hubrecht/loadcredential";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ thubrecht ];
  };
}
