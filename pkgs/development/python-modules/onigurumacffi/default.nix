{
  lib,
  python3Packages,
  fetchPypi,
  oniguruma,
}:
python3Packages.buildPythonPackage rec {
  pname = "onigurumacffi";
  version = "1.3.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-d0XNxWCWrOyIofOwhmCiKwnGWe040/WdtsHK12qXa+8=";
  };

  buildInputs = with python3Packages; [
    oniguruma
    setuptools
    cffi
  ];

  meta = with lib; {
    description = "Python cffi bindings for the oniguruma regex engine";
    homepage = "https://github.com/asottile/onigurumacffi";
    license = licenses.mit;
    maintainers = with maintainers; [ melkor333 ];
  };
}
