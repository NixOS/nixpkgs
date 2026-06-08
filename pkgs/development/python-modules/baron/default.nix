{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  rply,
  pytestCheckHook,
  isPy3k,
}:

buildPythonPackage (finalAttrs: {
  pname = "baron";
  version = "0.10.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-r4Iq1E1OtCXIUW30I5rE/bqf2zmO935JJM18m0BFvC8=";
  };

  build-system = [ setuptools ];

  dependencies = [ rply ];

  nativeCheckInputs = [ pytestCheckHook ];

  doCheck = isPy3k;

  pythonImportsCheck = [ "baron" ];

  meta = {
    homepage = "https://github.com/PyCQA/baron";
    description = "Abstraction on top of baron, a FST for python to make writing refactoring code a realistic task";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ marius851000 ];
  };
})
