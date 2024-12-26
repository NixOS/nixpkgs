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
  version = "0.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "pynvim";
    rev = "refs/tags/${version}";
    hash = "sha256-/frugwYPS4rS4L6BRsmNb5pJI8xfLJvbr+PyOLx25a4=";
  };

  build-system = [ setuptools ];

  dependencies =
    [ msgpack ]
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
