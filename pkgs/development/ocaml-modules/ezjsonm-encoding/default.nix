{ lib, fetchurl, buildDunePackage, ezjsonm }:

buildDunePackage rec {
  pname = "ezjsonm-encoding";
  version = "2.0.0";

  src = fetchurl {
    url = "https://github.com/lthms/ezjsonm-encoding/releases/download/${version}/ezjsonm-encoding-${version}.tbz";
    hash = "sha256-e5OPcbbQLr16ANFNZ5i10LjlHgwcRTCYhyvOhVk22yI=";
  };

  propagatedBuildInputs = [ ezjsonm ];

  meta = {
    description = "Encoding combinators a la Data_encoding for Ezjsonm";
    homepage = "https://github.com/lthms/ezjsonmi-encoding";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ fgaz ];
  };
}
