{
  lib,
  fetchPypi,
  buildPythonPackage,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "intbitset";
  version = "4.1.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-+C+v4Ly0/noBDZQgmbWoTXIdN8iXU47WMveIliwUEfg=";
  };

  build-system = [ setuptools ];
  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "intbitset" ];

  meta = {
    description = "C-based extension implementing fast integer bit sets";
    homepage = "https://github.com/inveniosoftware/intbitset";
    changelog = "https://github.com/inveniosoftware-contrib/intbitset/blob/v${finalAttrs.version}/CHANGELOG.rst";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
})
