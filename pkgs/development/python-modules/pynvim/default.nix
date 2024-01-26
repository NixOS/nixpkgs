{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, msgpack
, greenlet
, pythonOlder
, isPyPy
}:

buildPythonPackage rec {
  pname = "pynvim";
  version = "0.5.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "pynvim";
    rev = "refs/tags/${version}";
    hash = "sha256-3LqgKENFzdfCjMlD6Xzv5W23yvIkNMUYo2+LlzKZ3cc=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace " + pytest_runner" ""
  '';

  buildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    msgpack
  ] ++ lib.optionals (!isPyPy) [
    greenlet
  ];

  # Tests require pkgs.neovim which we cannot add because of circular dependency
  doCheck = false;

  pythonImportsCheck = [
    "pynvim"
  ];

  meta = with lib; {
    description = "Python client for Neovim";
    homepage = "https://github.com/neovim/pynvim";
    changelog = "https://github.com/neovim/pynvim/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
