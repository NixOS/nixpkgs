{ buildPythonPackage
, fetchPypi
, zope_interface
, sphinx, manuel
}:

buildPythonPackage rec {
  pname = "persistent";
  version = "4.5.0";

  nativeBuildInputs = [ sphinx manuel ];
  propagatedBuildInputs = [ zope_interface ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0slbvq1m3rilgyhj6i522rsyv592xv9pmvm61mrmgkgf40kfnz69";
  };

  meta = {
    description = "Automatic persistence for Python objects";
    homepage = http://www.zope.org/Products/ZODB;
  };
}
