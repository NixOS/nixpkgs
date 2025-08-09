{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
}:

buildPythonPackage rec {
  pname = "deep-chainmap";
  version = "0.1.2";
  pyproject = true;

  src = fetchPypi {
    pname = "deep_chainmap";
    inherit version;
    hash = "sha256-R7Pfh+1bYJ7LCU+0SyZi2XGOsgL1zWiMkp1z9HD1I1w=";
  };

  build-system = [ hatchling ];

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
