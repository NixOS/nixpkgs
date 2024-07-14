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
    hash = "sha256-osfS5Seg6JhlrC5uc/GYuCm4ccgm807rTvsJZp4ewKw=";
  };

  pythonImportsCheck = [ "cjkwrap" ];

  meta = with lib; {
    description = "Library for wrapping and filling CJK text";
    homepage = "https://f.gallai.re/cjkwrap";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.kaction ];
  };
}
