{ lib
, buildPythonPackage
, fetchPypi
, zope_interface, cffi
, sphinx, manuel
}:

buildPythonPackage rec {
  pname = "persistent";
  version = "4.5.1";

  nativeBuildInputs = [ sphinx manuel ];
  propagatedBuildInputs = [ zope_interface cffi ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "73862779577cb8637f2b68e7edee9a9b95cf33d0b83cb6e762f0f3fc12897aa6";
  };

  meta = {
    description = "Automatic persistence for Python objects";
    homepage = "http://www.zodb.org/";
    license = lib.licenses.zpl21;
  };
}
