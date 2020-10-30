{ buildPythonPackage, fetchPypi, atpublic, zope_interface, nose2 }:

buildPythonPackage rec {
  pname = "flufl.bounce";
  version = "3.0.1";

  buildInputs = [ nose2 ];
  propagatedBuildInputs = [ atpublic zope_interface ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "e432fa1ca25ddbf23e2716b177d4d1c6ab6c078e357df56b0106b92bc10a8f06";
  };
}
