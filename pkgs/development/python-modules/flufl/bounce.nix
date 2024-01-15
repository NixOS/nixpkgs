{ buildPythonPackage, fetchPypi, atpublic, zope-interface, nose2 }:

buildPythonPackage rec {
  pname = "flufl.bounce";
  version = "4.0";

  buildInputs = [ nose2 ];
  propagatedBuildInputs = [ atpublic zope-interface ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JVBK65duwP5aGc1sQTo0EMtRT9zb3Kn5tdjTQ6hgODE=";
  };
}
