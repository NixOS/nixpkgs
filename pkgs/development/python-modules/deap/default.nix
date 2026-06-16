{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  matplotlib,
  numpy,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "deap";
  version = "1.4.3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "deap";
    hash = "sha256-fJcIj7BYNb3CVb7EdcsOd43itD5Ey++/K81lWu7IZf0=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    matplotlib
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
