{
  lib,
  fetchPypi,
  buildPythonPackage,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "colorama";
  version = "0.4.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CGlfXLftbgUxogVyaXKXJzxHuMrlpj/8bW7VwgG+bkQ=";
  };

  nativeBuildInputs = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "colorama" ];

  meta = {
    description = "Cross-platform colored terminal text";
    homepage = "https://github.com/tartley/colorama";
    changelog = "https://github.com/tartley/colorama/raw/${version}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
