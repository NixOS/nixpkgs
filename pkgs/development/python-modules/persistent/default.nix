{ lib
, buildPythonPackage
, fetchPypi
, zope_interface, cffi
, sphinx, manuel
}:

buildPythonPackage rec {
  pname = "persistent";
  version = "4.7.0";

  nativeBuildInputs = [ sphinx manuel ];
  propagatedBuildInputs = [ zope_interface cffi ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ef7c05a6dca0104dc224fe7ff31feb30a63d970421c9462104a4752148ac333";
  };

  meta = {
    description = "Automatic persistence for Python objects";
    homepage = "http://www.zodb.org/";
    license = lib.licenses.zpl21;
  };
}
