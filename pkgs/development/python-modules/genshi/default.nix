{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "genshi";
  version = "0.7.11";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gsT5u/SwO+UWKiTW2OT9v+PtJgLT68v1BaMzUKN53Lc=";
  };

  build-system = [ setuptools ];

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
