{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "genshi";
  version = "0.7.10";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hbDbETYlMU8PRPP+bvDrJWTWw03S7lZ3tJXRUUK7SXM=";
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
