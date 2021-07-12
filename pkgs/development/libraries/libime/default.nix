{ lib, stdenv
, fetchurl
, fetchFromGitHub
, cmake
, extra-cmake-modules
, boost
, python3
, fcitx5
}:

let
  table = fetchurl {
    url = "https://download.fcitx-im.org/data/table.tar.gz";
    sha256 = "1dw7mgbaidv3vqy0sh8dbfv8631d2zwv5mlb7npf69a1f8y0b5k1";
  };
  arpaVer = "20140820";
  arpa = fetchurl {
    url = "https://download.fcitx-im.org/data/lm_sc.3gm.arpa-${arpaVer}.tar.bz2";
    sha256 = "0bqy3l7mif0yygjrcm65qallszgn17mvgyxhvz7a54zaamyan6vm";
  };
  dictVer = "20210402";
  dict = fetchurl {
    url = "https://download.fcitx-im.org/data/dict.utf8-${dictVer}.tar.xz";
    sha256 = "sha256-gYz7tama5bQMJwe2FYc09KEBlkRIU0AMvWsUUFWS2A0=";
  };
in
stdenv.mkDerivation rec {
  pname = "libime";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "libime";
    rev = version;
    sha256 = "sha256-q/SXS6pT4vBkCkCTarPVHrZPXijYnc2t51YGRvzQ0FY=";
    fetchSubmodules = true;
  };

  prePatch = ''
    ln -s ${table} data/$(stripHash ${table})
    ln -s ${arpa} data/$(stripHash ${arpa})
    ln -s ${dict} data/$(stripHash ${dict})
  '';

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    python3
  ];

  buildInputs = [
    boost
    fcitx5
  ];

  meta = with lib; {
    description = "A library to support generic input method implementation";
    homepage = "https://github.com/fcitx/libime";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ poscat ];
    platforms = platforms.linux;
  };
}
