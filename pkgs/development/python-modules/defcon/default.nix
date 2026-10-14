{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  fonttools,
  fontpens,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "defcon";
  version = "0.12.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-Jd/n/QFSzPKSyxkNGSikfViImcILBGhUKT4DnhyT5eA=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    fonttools
  ]
  ++ fonttools.optional-dependencies.ufo
  ++ fonttools.optional-dependencies.unicode;

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "defcon" ];

  optional-dependencies = {
    pens = [ fontpens ];
    lxml = [ fonttools ] ++ fonttools.optional-dependencies.lxml;
  };

  meta = {
    description = "Set of UFO based objects for use in font editing applications";
    homepage = "https://github.com/robotools/defcon";
    changelog = "https://github.com/robotools/defcon/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sternenseemann ];
  };
})
