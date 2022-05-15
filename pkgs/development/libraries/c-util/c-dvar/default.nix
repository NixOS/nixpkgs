{ lib, stdenv, fetchFromGitHub, pkg-config, meson, ninja
, c-stdaux, c-utf8 }:

stdenv.mkDerivation rec {
  pname = "c-dvar";
  version = "unstable-2022-05-03";

  nativeBuildInputs = [
    meson ninja pkg-config
    c-stdaux c-utf8
  ];

  src = fetchFromGitHub {
    owner = "c-util";
    repo = "c-dvar";
    rev = "139ea946b0c4f711d0eb07bc7b282eec43c81085";
    sha256 = "1v2ddqy24mr8j5flalyayxrvs571vix0vcxmfpk10ryl76q2j02s";
  };

  meta = with lib; {
    description = "Common Utility Libraries for C11";
    homepage    = "https://c-util.github.io/c-dvar/";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ xaverdh ];
  };
}
