{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  moocore,
  numpy,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "deap";
  version = "1.4.4";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "deap";
    hash = "sha256-UNS9kk/KWhaj26i/2xFApV6cJM5QgWq09Wg9LzHC1zQ=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    moocore
    numpy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Novel evolutionary computation framework for rapid prototyping and testing of ideas";
    homepage = "https://github.com/DEAP/deap";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [
      getpsyched
      psyanticy
    ];
  };
})
