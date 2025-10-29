{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
}:

buildPythonPackage rec {
  pname = "deep-chainmap";
  version = "0.1.3";
  pyproject = true;

  src = fetchPypi {
    pname = "deep_chainmap";
    inherit version;
    hash = "sha256-Cw6Eiey501mzeigfdwnMuZH28abG4rcoACUGlmkzECA=";
  };

  build-system = [ flit-core ];

  # Tests are not published to pypi
  doCheck = false;

  pythonImportsCheck = [ "deep_chainmap" ];

  # See the guide for more information: https://nixos.org/nixpkgs/manual/#chap-meta
  meta = with lib; {
    description = "Recursive subclass of ChainMap";
    homepage = "https://github.com/neutrinoceros/deep_chainmap";
    license = licenses.mit;
    maintainers = with maintainers; [ rehno-lindeque ];
  };
}
