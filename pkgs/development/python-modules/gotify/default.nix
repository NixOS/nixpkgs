{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  nix-update-script,
  httpx,
  websockets,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "gotify";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "d-k-bo";
    repo = "python-gotify";
    rev = "v${version}";
    hash = "sha256-epm8m2W+ChOvWHZi2ruAD+HJGj+V7NfhmFLKeeqcpoI=";
  };

  build-system = [ flit-core ];

  dependencies = [
    httpx
    websockets
  ];

  pythonImportsCheck = [
    "gotify"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/d-k-bo/python-gotify/releases/tag/v${version}";
    description = "Python library to access your gotify server";
    homepage = "https://github.com/d-k-bo/python-gotify";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.joblade
    ];
  };
}
