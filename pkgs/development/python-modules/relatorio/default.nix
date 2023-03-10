{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, genshi
, lxml
, pyyaml
, python-magic
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "relatorio";
  version = "0.10.1";

  disabled = pythonOlder "3.5";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a0c72302d50d5dfa433ddab191672eec1dde1c6ed26330a378b720e5a3012e23";
  };

  propagatedBuildInputs = [
    genshi
    lxml
  ];

  passthru.optional-dependencies = {
    chart = [ /* pycha */ pyyaml ];
    fodt = [ python-magic ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ passthru.optional-dependencies.fodt;

  pythonImportsCheck = [ "relatorio" ];

  meta = {
    homepage = "https://relatorio.tryton.org/";
    changelog = "https://hg.tryton.org/relatorio/file/${version}/CHANGELOG";
    description = "A templating library able to output odt and pdf files";
    maintainers = with lib.maintainers; [ johbo ];
    license = lib.licenses.gpl2Plus;
  };
}
