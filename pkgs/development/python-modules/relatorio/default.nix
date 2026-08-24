{
  lib,
  buildPythonPackage,
  fetchPypi,
  genshi,
  lxml,
  pyyaml,
  python-magic,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "relatorio";
  version = "0.12.1";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Jh5HxN8Ey2PbNL1TQ3cHLHhB1vlfndmGwTlD2klR/U4=";
  };

  propagatedBuildInputs = [
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
    homepage = "https://relatorio.tryton.org/";
    changelog = "https://hg.tryton.org/relatorio/file/${version}/CHANGELOG";
    description = "Templating library able to output odt and pdf files";
    mainProgram = "relatorio-render";
    maintainers = with lib.maintainers; [ johbo ];
    license = lib.licenses.gpl2Plus;
  };
}
