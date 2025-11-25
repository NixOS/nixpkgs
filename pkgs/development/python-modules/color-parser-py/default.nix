{
  lib,
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "color-parser-py";
  version = "0.1.6";
  pyproject = true;

  # PyPI has Cargo.lock
  src = fetchPypi {
    pname = "color_parser_py";
    inherit version;
    hash = "sha256-m1qhVAwQNtCwz+DLSAdfKhzkohMLMjvPHxynKhlJfN8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-tKXA6sd5gLCJUaqxzFcZ3lePK41Wk2TbLp0HXBacOyo=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "color_parser_py" ];

  # Support newer python versions
  env.PYO3_USE_ABI3_FORWARD_COMPATIBILITY = true;

  meta = {
    description = "Python bindings for color parsing and conversion";
    homepage = "https://github.com/rusiaaman/color-parser-py";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aleksana ];
  };
}
