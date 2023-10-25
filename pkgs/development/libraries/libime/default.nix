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
  arpaVer = "20220810";
  arpa = fetchurl {
    url = "https://download.fcitx-im.org/data/lm_sc.arpa-${arpaVer}.tar.xz";
    sha256 = "sha256-oRvJfSda2vGV+brIVDaK4GzbSg/h7s9Z21rlgGFdtPo=";
  };
  dictVer = "20220810";
  dict = fetchurl {
    url = "https://download.fcitx-im.org/data/dict-${dictVer}.tar.xz";
    sha256 = "sha256-lxdS9BMYgAfo0ZFYwRuFyVXiXXsyHsInXEs69tioXSY=";
  };
in
stdenv.mkDerivation rec {
  pname = "libime";
  version = "1.0.17";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "libime";
    rev = version;
    sha256 = "sha256-mc0Mknqki0pY4oKf8B6H67N+1eMu7wbqF7wES22Kw1A=";
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
