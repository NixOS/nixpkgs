{ lib, buildPythonPackage, fetchurl }:

buildPythonPackage rec {
  name = "pylnk-${version}";
  version = "0.2";

  src = fetchurl {
    url = "mirror://pypi/p/pylnk/${name}.tar.gz";
    sha256 = "13pyz4spyx2fxb3afp95qqpzpbwxb2q0sll7hlv6a1sw1p0vcggd";
  };

  meta = with lib; {

    description = "Windows LNK File Parser and Creator";
    homepage = "http://sourceforge.net/projects/pylnk/";
    license = licenses.lgpl;
    maintainers = with maintainers; [ fpletz ];
  };
}
