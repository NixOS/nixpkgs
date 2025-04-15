{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "deep-chainmap";
  version = "0.1.2";
  format = "setuptools";

  src = fetchPypi {
    pname = "deep_chainmap";
    inherit version;
    hash = "sha256-R7Pfh+1bYJ7LCU+0SyZi2XGOsgL1zWiMkp1z9HD1I1w=";
  };

  # Tests are not published to pypi
  doCheck = false;

  pythonImportsCheck = [ "deep_chainmap" ];

  # See the guide for more information: https://nixos.org/nixpkgs/manual/#chap-meta
  meta = with lib; {
    description = "Recursive subclass of ChainMap";
    homepage = "https://github.com/neutrinoceros/deep-chainmap";
    license = licenses.mit;
    maintainers = with maintainers; [ rehno-lindeque ];
  };
}
