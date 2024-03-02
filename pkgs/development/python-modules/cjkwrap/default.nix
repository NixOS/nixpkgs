{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "CJKwrap";
  version = "2.2";
  src = fetchPypi {
    inherit pname version;
    sha256 = "1b603sg6c2gv9vmlxwr6r1qvhadqk3qp6vifmijris504zjx5ix2";
  };

  pythonImportsCheck = [ "cjkwrap" ];

  meta = with lib; {
    description = "A library for wrapping and filling CJK text";
    homepage = "https://f.gallai.re/cjkwrap";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.kaction ];
  };
}
