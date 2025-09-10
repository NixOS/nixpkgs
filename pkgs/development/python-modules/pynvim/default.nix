{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  msgpack,
  isPyPy,
  greenlet,
  pythonOlder,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "pynvim";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "pynvim";
    tag = version;
    hash = "sha256-Wxn4g/lFelAJx0Zz2yaeXqX56xeOWUJNb2p8EiJgKE0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    msgpack
  ]
  ++ lib.optionals (!isPyPy) [ greenlet ]
  ++ lib.optionals (pythonOlder "3.12") [ typing-extensions ];

  # Tests require pkgs.neovim which we cannot add because of circular dependency
  doCheck = false;

  pythonImportsCheck = [ "pynvim" ];

  meta = {
    description = "Python client for Neovim";
    homepage = "https://github.com/neovim/pynvim";
    changelog = "https://github.com/neovim/pynvim/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ figsoda ];
  };
}
