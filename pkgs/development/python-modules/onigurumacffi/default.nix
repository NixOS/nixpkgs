{
  lib,
  buildPythonPackage,
  fetchPypi,
  oniguruma,
  setuptools,
  cffi,
}:
buildPythonPackage rec {
  pname = "onigurumacffi";
  version = "1.4.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-W/vB725dEXniJFP4JDeoJPnVdx4M5l86csprnGEiZTY=";
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
}
