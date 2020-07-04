{ lib
, buildPythonPackage
, fetchPypi
, zope_interface, cffi
, sphinx, manuel
}:

buildPythonPackage rec {
  pname = "persistent";
  version = "4.6.4";

  nativeBuildInputs = [ sphinx manuel ];
  propagatedBuildInputs = [ zope_interface cffi ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "f83f54355a44cf8ec38c29ce47b378a8c70444e9a745581dbb13d201a24cb546";
  };

  meta = {
    description = "Automatic persistence for Python objects";
    homepage = "http://www.zodb.org/";
    license = lib.licenses.zpl21;
  };
}
