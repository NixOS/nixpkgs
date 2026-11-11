{
  lib,
  fetchPypi,
  buildPythonPackage,
  python,
  dawg-python,
  docopt,
  pymorphy2-dicts-ru,
  pkg-resources-backport,
}:

buildPythonPackage (finalAttrs: {
  pname = "pymorphy2";
  version = "0.9.1";
  format = "setuptools";

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-hsRHFX3uLrI0HvvkU44SgadUdWuhqjLad6iWFMWLVgw=";
  };

  postPatch = ''
    substituteInPlace pymorphy2/units/base.py \
      --replace-fail "args, varargs, kw, default = inspect.getargspec(cls.__init__)" "args = inspect.getfullargspec(cls.__init__).args"
  '';

  propagatedBuildInputs = [
    dawg-python
    docopt
    pymorphy2-dicts-ru
    pkg-resources-backport
  ];

  pythonImportsCheck = [ "pymorphy2" ];

  # Substitute for the sdist not packaging tests
  installCheckPhase = ''
    runHook preInstallCheck
    PYTHONPATH="$out/${python.sitePackages}:$PYTHONPATH" \
      python -c "import pymorphy2; pymorphy2.MorphAnalyzer()"
    runHook postInstallCheck
  '';

  meta = {
    description = "Morphological analyzer/inflection engine for Russian and Ukrainian";
    mainProgram = "pymorphy";
    homepage = "https://github.com/kmike/pymorphy2";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
