{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  pytestCheckHook,
  tinycss2,
}:

buildPythonPackage (finalAttrs: {
  pname = "cssselect2";
  version = "0.9.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-dZqiLCFjJjVvZeYueR1mFgoPnJHRQk6NitxedN3fxvs=";
  };

  postPatch = ''
    sed -i '/^addopts/d' pyproject.toml
  '';

  build-system = [ flit-core ];

  dependencies = [ tinycss2 ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cssselect2" ];

  meta = {
    description = "CSS selectors for Python ElementTree";
    homepage = "https://github.com/Kozea/cssselect2";
    changelog = "https://github.com/Kozea/cssselect2/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
