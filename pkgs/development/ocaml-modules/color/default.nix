{
  lib,
  fetchurl,
  buildDunePackage,
  gg,
}:

buildDunePackage rec {
  pname = "color";
  version = "0.2.0";

  useDune2 = true;
  minimalOCamlVersion = "4.05";

  src = fetchurl {
    url = "https://github.com/anuragsoni/color/releases/download/${version}/color-${version}.tbz";
    sha256 = "0wg3a36i1a7fnz5pf57qzbdghwr6dzp7nnxyrz9m9765lxsn65ph";
  };

  propagatedBuildInputs = [
    gg
  ];

  meta = with lib; {
    description = "Converts between different color formats";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
    homepage = "https://github.com/anuragsoni/color";
  };
}
