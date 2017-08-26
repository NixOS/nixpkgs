{ buildPythonPackage
, fetchPypi
, zope_interface
, pkgs
}:

buildPythonPackage rec {
  pname = "persistent";
  version = "4.2.4.2";
  name = "${pname}-${version}";

  propagatedBuildInputs = [ zope_interface ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "cf264cd55866c7ffbcbe1328f8d8b28fd042a5dd0c03a03f68c0887df3aa1964";
  };

  meta = {
    description = "Automatic persistence for Python objects";
    homepage = http://www.zope.org/Products/ZODB;
  };
}
