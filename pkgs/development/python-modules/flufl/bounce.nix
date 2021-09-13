{ buildPythonPackage, fetchPypi, atpublic, zope_interface, nose2 }:

buildPythonPackage rec {
  pname = "flufl.bounce";
  version = "4.0";

  buildInputs = [ nose2 ];
  propagatedBuildInputs = [ atpublic zope_interface ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "25504aeb976ec0fe5a19cd6c413a3410cb514fdcdbdca9f9b5d8d343a8603831";
  };
}
