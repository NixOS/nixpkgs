{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage {
  pname = "pypresence";
  version = "4.3.0-unstable-2025-03-27";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "qwertyquerty";
    repo = "pypresence";
    rev = "4e882c36d0f800c016c15977243ac9a49177095a";
    hash = "sha256-DjwDmQMbI9tV40TTe1CthhphoysKSFICrRhqijJjIAE=";
  };

  build-system = [ setuptools ];

  doCheck = false; # tests require internet connection
  pythonImportsCheck = [ "pypresence" ];

  meta = {
    homepage = "https://qwertyquerty.github.io/pypresence/html/index.html";
    description = "Discord RPC client written in Python";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
