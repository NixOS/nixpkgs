{ lib, stdenv, buildPythonPackage, fetchPypi, psutil, docutils }:

buildPythonPackage rec {
  pname = "pynisher";
  version = "0.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e4e1d9366fc4ca60b4b2354b6d12e65600600a8c7bf4392c84f2f4ff4abc85ff";
  };

  propagatedBuildInputs = [ psutil docutils ];

  # no tests in the Pypi archive
  doCheck = false;

  meta = with lib; {
    description = "The pynisher is a little module intended to limit a functions resources.";
    homepage = "https://github.com/sfalkner/pynisher";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };

}

