{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools_80,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "genshi";
  version = "0.7.12";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-S8ohpaJRXav5hRdr6Jels7YkYmtKn8tkhyC3xfq3Fic=";
  };

  build-system = [ setuptools_80 ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Python components for parsing HTML, XML and other textual content";
    longDescription = ''
      Python library that provides an integrated set of components for
      parsing, generating, and processing HTML, XML or other textual
      content for output generation on the web.
    '';
    homepage = "https://genshi.edgewall.org/";
    license = lib.licenses.bsd0;
  };
}
