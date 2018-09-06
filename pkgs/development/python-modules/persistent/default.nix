{ buildPythonPackage
, fetchPypi
, zope_interface
}:

buildPythonPackage rec {
  pname = "persistent";
  version = "4.4.2";

  propagatedBuildInputs = [ zope_interface ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "451c756b4f4faa5f06f87d57f5928758bb3a16a586ceaa8773c35367188eddf9";
  };

  meta = {
    description = "Automatic persistence for Python objects";
    homepage = http://www.zope.org/Products/ZODB;
  };
}
