{
  lib,
  buildPythonPackage,
  fetchPypi,
  hypothesis,
  lxml,
  matplotlib,
  networkx,
  pydot,
  pytestCheckHook,
  python-dateutil,
  rdflib,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "prov";
  version = "2.5.3";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-tNI2zwHDszvf331fZ68k0xxHFvJZ4PtzHo36zz1URp4=";
  };

  build-system = [ setuptools ];

  dependencies = [ python-dateutil ];

  optional-dependencies = {
    dot = [
      networkx
      pydot
    ];
    graph = [ networkx ];
    rdf = [ rdflib ];
    plot = [
      matplotlib
      networkx
      pydot
    ];
    xml = [ lxml ];
  };

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "prov" ];

  preCheck = ''
    export PATH="$PATH:$out/bin";
  '';

  meta = {
    description = "Python library for W3C Provenance Data Model (PROV)";
    homepage = "https://github.com/trungdong/prov";
    changelog = "https://github.com/trungdong/prov/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ashgillman ];
    mainProgram = "prov-convert";
  };
})
