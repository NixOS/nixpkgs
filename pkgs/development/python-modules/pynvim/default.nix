{ lib
, buildPythonPackage
, fetchFromGitHub
, msgpack
, greenlet
, pythonOlder
, isPyPy
}:

buildPythonPackage rec {
  pname = "pynvim";
  version = "0.4.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "pynvim";
    rev = "refs/tags/${version}";
    hash = "sha256-8sgVJh143L9qaoTMC67K8ays+qUF6OufIZE3sb0HXyQ=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace " + pytest_runner" ""
  '';

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
