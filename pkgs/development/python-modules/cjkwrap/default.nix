{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "cjkwrap";
  version = "2.2";
  src = fetchPypi {
    pname = "CJKwrap";
    inherit version;
    sha256 = "1b603sg6c2gv9vmlxwr6r1qvhadqk3qp6vifmijris504zjx5ix2";
  };

  pythonImportsCheck = [ "cjkwrap" ];

  meta = {
    description = "Library for wrapping and filling CJK text";
    homepage = "https://f.gallai.re/cjkwrap";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.kaction ];
  };
}
