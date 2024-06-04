{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  genshi,
  lxml,
  pyyaml,
  python-magic,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "relatorio";
  version = "0.10.2";

  disabled = pythonOlder "3.5";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-zgCOmcR9FWj0lpi78U0G1CKR5kyNyr541HusIrBpF/Q=";
  };

  propagatedBuildInputs = [
    genshi
    lxml
  ];

  passthru.optional-dependencies = {
    chart = [
      # pycha
      pyyaml
    ];
    fodt = [ python-magic ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ passthru.optional-dependencies.fodt;

  pythonImportsCheck = [ "relatorio" ];

  meta = {
    homepage = "https://relatorio.tryton.org/";
    changelog = "https://hg.tryton.org/relatorio/file/${version}/CHANGELOG";
    description = "A templating library able to output odt and pdf files";
    mainProgram = "relatorio-render";
    maintainers = with lib.maintainers; [ johbo ];
    license = lib.licenses.gpl2Plus;
  };
}
