{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  flit-core,
  gpsoauth,
  future,
}:
buildPythonPackage {
  pname = "gkeepapi";
  version = "0.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kiwiz";
    repo = "gkeepapi";
    # No tagged release, lock to latest commit.
    rev = "d56a9e388dc66a51ec7d0dd37e443c2beb37f5a7";
    hash = "sha256-JCFIfhvR4R/YG+w4Me7VYECSnTCfAgcApB+2mub+q68=";
  };

  build-system = [ flit-core ];

  buildInputs = [
    gpsoauth
    future
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "gkeepapi" ];

  meta = {
    description = "An unofficial client for the Google Keep API.";
    homepage = "https://github.com/kiwiz/gkeepapi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ shymega ];
  };
}
