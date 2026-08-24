{
  lib,
  buildPythonPackage,
  fetchPypi,
  more-itertools,
  inflect,
  jaraco-functools,
  jaraco-context,
  pytestCheckHook,
  setuptools-scm,
  typer,
}:

buildPythonPackage (finalAttrs: {
  pname = "jaraco-text";
  version = "4.3.0";
  pyproject = true;

  src = fetchPypi {
    pname = "jaraco_text";
    inherit (finalAttrs) version;
    hash = "sha256-3dXrYlnQcB4Iy2QsjWtjvMc5R9A9+SOepnu++RGz5OE=";
  };

  pythonRemoveDeps = [ "typer-slim" ];

  postPatch = ''
    # downloads license texts at build time
    sed -i "/coherent\.licensed/d" pyproject.toml
  '';

  pythonNamespaces = [ "jaraco" ];

  build-system = [ setuptools-scm ];

  dependencies = [
    more-itertools
    jaraco-context
    jaraco-functools
    typer
  ];

  nativeCheckInputs = [
    inflect
    pytestCheckHook
  ];

  pythonImportsCheck = [ "jaraco.text" ];

  meta = {
    description = "Module for text manipulation";
    homepage = "https://github.com/jaraco/jaraco.text";
    changelog = "https://github.com/jaraco/jaraco.text/blob/v${finalAttrs.version}/NEWS.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
