<<<<<<< HEAD
{ lib
, stdenv
=======
{ lib, stdenv
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  arpaVer = "20230712";
  arpa = fetchurl {
    url = "https://download.fcitx-im.org/data/lm_sc.arpa-${arpaVer}.tar.xz";
    hash = "sha256-ut1iwWxjc3h6D9qPCc1FLRL2DVhohW9lHO7PGge6ujI=";
  };
  dictVer = "20230412";
  dict = fetchurl {
    url = "https://download.fcitx-im.org/data/dict-${dictVer}.tar.xz";
    hash = "sha256-8F/Mr/loeQCqw9mtWoGyCIi1cyAUA/vNm7x5B9npdQc=";
=======
  arpaVer = "20220810";
  arpa = fetchurl {
    url = "https://download.fcitx-im.org/data/lm_sc.arpa-${arpaVer}.tar.xz";
    sha256 = "sha256-oRvJfSda2vGV+brIVDaK4GzbSg/h7s9Z21rlgGFdtPo=";
  };
  dictVer = "20220810";
  dict = fetchurl {
    url = "https://download.fcitx-im.org/data/dict-${dictVer}.tar.xz";
    sha256 = "sha256-lxdS9BMYgAfo0ZFYwRuFyVXiXXsyHsInXEs69tioXSY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
in
stdenv.mkDerivation rec {
  pname = "libime";
<<<<<<< HEAD
  version = "1.1.0";
=======
  version = "1.0.17";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "libime";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-r1Px93Ly7FzcRaPUNTHNcedzHPHocnUj8t8VMZqXkFM=";
=======
    sha256 = "sha256-mc0Mknqki0pY4oKf8B6H67N+1eMu7wbqF7wES22Kw1A=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
