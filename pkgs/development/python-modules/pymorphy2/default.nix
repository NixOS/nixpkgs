{
  lib,
  fetchPypi,
  buildPythonPackage,
  isPy3k,
  dawg-python,
  docopt,
  pymorphy2-dicts-ru,
}:

buildPythonPackage rec {
  pname = "pymorphy2";
  version = "0.9.1";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hsRHFX3uLrI0HvvkU44SgadUdWuhqjLad6iWFMWLVgw=";
  };

  propagatedBuildInputs = [
    dawg-python
    docopt
    pymorphy2-dicts-ru
  ];

  pythonImportsCheck = [ "pymorphy2" ];

<<<<<<< HEAD
  meta = {
    description = "Morphological analyzer/inflection engine for Russian and Ukrainian";
    mainProgram = "pymorphy";
    homepage = "https://github.com/kmike/pymorphy2";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Morphological analyzer/inflection engine for Russian and Ukrainian";
    mainProgram = "pymorphy";
    homepage = "https://github.com/kmike/pymorphy2";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
