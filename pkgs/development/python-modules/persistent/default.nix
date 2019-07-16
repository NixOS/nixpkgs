{ lib
, buildPythonPackage
, fetchPypi
, zope_interface, cffi
, sphinx, manuel
}:

buildPythonPackage rec {
  pname = "persistent";
  version = "4.5.0";

  nativeBuildInputs = [ sphinx manuel ];
  propagatedBuildInputs = [ zope_interface cffi ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0slbvq1m3rilgyhj6i522rsyv592xv9pmvm61mrmgkgf40kfnz69";
  };

  meta = {
    description = "Automatic persistence for Python objects";
    homepage = "http://www.zodb.org/";
    license = lib.licenses.zpl21;
  };
}
