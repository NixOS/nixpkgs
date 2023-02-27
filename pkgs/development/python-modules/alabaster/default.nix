{ lib, buildPythonPackage, fetchPypi
, pygments }:

buildPythonPackage rec {
  pname = "alabaster";
  version = "0.7.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-onpKCE1eaQ4W4B4DrSsuVSxhplRpQZuQckMZPeGoSuI=";
  };

  propagatedBuildInputs = [ pygments ];

  # No tests included
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/bitprophet/alabaster";
    description = "A Sphinx theme";
    license = licenses.bsd3;
  };
}
