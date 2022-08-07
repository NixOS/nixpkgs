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
  arpaVer = "20220630";
  arpa = fetchurl {
    url = "https://download.fcitx-im.org/data/lm_sc.arpa-${arpaVer}.tar.xz";
    sha256 = "sha256-jTsPqPoWuT0NRZDwLaBAKcJxNktZJcHJAoRcN0oqAL8=";
  };
  dictVer = "20220706";
  dict = fetchurl {
    url = "https://download.fcitx-im.org/data/dict-${dictVer}.tar.xz";
    sha256 = "sha256-vNeR//eDr7QMHI6S2z+Dc0+Lk8nGriwV4eqHeLkHB3k=";
  };
in
stdenv.mkDerivation rec {
  pname = "libime";
  version = "unstable-2022-07-11";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "libime";
    rev = "1adb14eb0617ef0eb0f07ad99684f43ca8a4395c";
    sha256 = "sha256-UldswsnkMuJh2G/EdsFl4CS7Y2RSRAb1hYeWUA2MHPw=";
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
