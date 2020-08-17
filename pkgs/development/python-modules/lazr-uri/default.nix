{ lib
, buildPythonPackage
, isPy27
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "lazr.uri";
  version = "1.0.5";

  disabled = isPy27; # namespace is broken for python2

  src = fetchPypi {
    inherit pname version;
    sha256 = "f36e7e40d5f8f2cf20ff2c81784a14a546e6c19c216d40a6617ebe0c96c92c49";
  };

  propagatedBuildInputs = [ setuptools ];

  meta = with lib; {
    description = "A self-contained, easily reusable library for parsing, manipulating";
    homepage = "https://launchpad.net/lazr.uri";
    license = licenses.lgpl3;
    maintainers = [ maintainers.marsam ];
  };
}
