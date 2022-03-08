{ lib
, buildPythonPackage
, fetchPypi
, zope_interface, cffi
, sphinx, manuel
}:

buildPythonPackage rec {
  pname = "persistent";
  version = "4.8.0";

  nativeBuildInputs = [ sphinx manuel ];
  propagatedBuildInputs = [ zope_interface cffi ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-nRd+rT+jwfXWKjbUUmdUs3bgUEx9S3XLmqUvt3HexrI=";
  };

  meta = {
    description = "Automatic persistence for Python objects";
    homepage = "http://www.zodb.org/";
    license = lib.licenses.zpl21;
  };
}
