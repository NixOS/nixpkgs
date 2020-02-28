{ lib
, buildPythonPackage
, isPy27
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "lazr.uri";
  version = "1.0.3";

  disabled = isPy27; # namespace is broken for python2

  src = fetchPypi {
    inherit pname version;
    sha256 = "5c620b5993c8c6a73084176bfc51de64972b8373620476ed841931a49752dc8b";
  };

  propagatedBuildInputs = [ setuptools ];

  meta = with lib; {
    description = "A self-contained, easily reusable library for parsing, manipulating";
    homepage = "https://launchpad.net/lazr.uri";
    license = licenses.lgpl3;
    maintainers = [ maintainers.marsam ];
  };
}
