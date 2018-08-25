{ buildPythonPackage
, fetchPypi
, zope_interface
}:

buildPythonPackage rec {
  pname = "persistent";
  version = "4.4.1";

  propagatedBuildInputs = [ zope_interface ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "2aedeaaf09fed52f63324b178d0addfe1c558340d68d04aafe85abafaafd8699";
  };

  meta = {
    description = "Automatic persistence for Python objects";
    homepage = http://www.zope.org/Products/ZODB;
  };
}
