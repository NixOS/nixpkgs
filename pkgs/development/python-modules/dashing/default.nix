{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  blessed,
}:

buildPythonPackage (finalAttrs: {
  pname = "dashing";
  version = "0.1.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-JRRgjg8pp3Xb0bERFWEhnOg9U8+kuqL+QQH6uE/Vbxs=";
  };

  build-system = [ setuptools ];

  dependencies = [ blessed ];

  pythonImportsCheck = [ "dashing" ];

  meta = {
    homepage = "https://github.com/FedericoCeratto/dashing";
    description = "Terminal dashboards for Python";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ juliusrickert ];
  };
})
