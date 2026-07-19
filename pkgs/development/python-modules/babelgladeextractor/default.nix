{
  lib,
  isPy3k,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  babel,
}:

buildPythonPackage (finalAttrs: {
  pname = "babelgladeextractor";
  version = "0.7.2";
  pyproject = true;

  __structuredAttrs = true;

  disabled = (!isPy3k); # uses python3 specific file io in setup.py

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-8LWmsQMPbgX0UbZld77m2WXn4VR+46lvfKoNlJ/GNv0=";
  };

  build-system = [ setuptools ];

  dependencies = [ babel ];

  # SyntaxError: Non-ASCII character '\xc3' in file /build/BabelGladeExtractor-0.6.3/babelglade/tests/test_translate.py on line 20, but no encoding declared; see http://python.org/dev/peps/pep-0263/ for details
  doCheck = isPy3k;

  pythonImportsCheck = [ "babelglade" ];

  meta = {
    homepage = "https://github.com/gnome-keysign/babel-glade";
    description = "Babel Glade XML files translatable strings extractor";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
