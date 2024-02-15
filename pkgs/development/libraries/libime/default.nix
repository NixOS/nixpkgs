{ lib
, stdenv
, fetchurl
, fetchFromGitHub
, cmake
, extra-cmake-modules
, boost
, python3
, fcitx5
, zstd
}:

let
  tableVer = "20240108";
  table = fetchurl {
    url = "https://download.fcitx-im.org/data/table-${tableVer}.tar.gz";
    hash = "sha256-cpxZbYaQfecnx00Pw/0kHEBsXevStMt07v4CI4funa4=";
  };
  arpaVer = "20230712";
  arpa = fetchurl {
    url = "https://download.fcitx-im.org/data/lm_sc.arpa-${arpaVer}.tar.xz";
    hash = "sha256-ut1iwWxjc3h6D9qPCc1FLRL2DVhohW9lHO7PGge6ujI=";
  };
  dictVer = "20230412";
  dict = fetchurl {
    url = "https://download.fcitx-im.org/data/dict-${dictVer}.tar.xz";
    hash = "sha256-8F/Mr/loeQCqw9mtWoGyCIi1cyAUA/vNm7x5B9npdQc=";
  };
in
stdenv.mkDerivation rec {
  pname = "libime";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "libime";
    rev = version;
    hash = "sha256-AvlQOpjrHSifUtWSTft2bywlWhwka26VcqqReqAlcv8=";
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
    zstd
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
