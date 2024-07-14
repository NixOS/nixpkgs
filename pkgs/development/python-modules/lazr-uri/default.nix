{
  lib,
  buildPythonPackage,
  isPy27,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "lazr.uri";
  version = "1.0.6";

  disabled = isPy27; # namespace is broken for python2

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UCaFP8v2+R1aaxHqeGCmQf4ns21Bcscx9KoWuQDPhGQ=";
  };

  propagatedBuildInputs = [ setuptools ];

  meta = with lib; {
    description = "Self-contained, easily reusable library for parsing, manipulating";
    homepage = "https://launchpad.net/lazr.uri";
    license = licenses.lgpl3;
    maintainers = [ ];
  };
}
