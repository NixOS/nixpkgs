{ lib, fetchPypi, buildPythonPackage, setuptools }:

buildPythonPackage rec {
  pname = "iso639-lang";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hFjktFv/bo1Emvw1/5tarvuVRAD+k6OfccN+W3ZumFY=";
  };

  propagatedBuildInputs = [ setuptools ];

  meta = with lib; {
    homepage = "https://github.com/LBeaudoux/iso639";
    description = "A lightweight Python library for the ISO 639 standard";
    license = licenses.mit;
    maintainers = with maintainers; [ gdinh ];
  };
}
