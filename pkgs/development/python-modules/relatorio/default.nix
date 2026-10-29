{
  lib,
  buildPythonPackage,
  fetchPypi,
  genshi,
  lxml,
  pyyaml,
  python-magic,
  pytestCheckHook,
  hatch-tryton,
  hatchling,
}:

buildPythonPackage rec {
  pname = "relatorio";
  version = "0.12.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Jh5HxN8Ey2PbNL1TQ3cHLHhB1vlfndmGwTlD2klR/U4=";
  };

  build-system = [
    hatch-tryton
    hatchling
  ];

  dependencies = [
    genshi
    lxml
  ];

  optional-dependencies = {
    chart = [
      # pycha
      pyyaml
    ];
    fodt = [ python-magic ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.fodt;

  pythonImportsCheck = [ "relatorio" ];

  meta = {
    description = "Templating library able to output odt and pdf files";
    homepage = "https://relatorio.tryton.org/";
    changelog = "https://hg.tryton.org/relatorio/file/${version}/CHANGELOG";
    maintainers = with lib.maintainers; [ johbo ];
    license = lib.licenses.gpl2Plus;
    mainProgram = "relatorio-render";
  };
}
