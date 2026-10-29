{
  lib,
  buildPythonPackage,
  fetchPypi,
  oniguruma,
  setuptools,
  cffi,
}:
buildPythonPackage (finalAttrs: {
  pname = "onigurumacffi";
  version = "1.5.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-1Pqb7kSm04qYsiN8Z9ms3yftDDLWwhgSX+RmgaXt6k0=";
  };

  buildInputs = [
    oniguruma
    setuptools
    cffi
  ];

  meta = {
    description = "Python cffi bindings for the oniguruma regex engine";
    homepage = "https://github.com/asottile/onigurumacffi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ melkor333 ];
  };
})
