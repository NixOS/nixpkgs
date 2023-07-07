{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "deep-chainmap";
  version = "0.1.1";

  src = fetchPypi {
    pname = "deep_chainmap";
    inherit version;
    hash = "sha256-6K7dyB5iQzzw3lXLcU10SVsiHZ+SAXhz9DSCkYnPQAA=";
  };

  # Tests are not published to pypi
  doCheck = false;

  pythonImportsCheck = [ "deep_chainmap" ];

  # See the guide for more information: https://nixos.org/nixpkgs/manual/#chap-meta
  meta = with lib; {
    description = "A recursive subclass of ChainMap";
    homepage = "https://github.com/neutrinoceros/deep-chainmap";
    license = licenses.mit;
    maintainers = with maintainers; [ rehno-lindeque ];
  };
}
