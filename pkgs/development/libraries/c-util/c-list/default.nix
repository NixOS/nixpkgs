{ lib, stdenv, fetchFromGitHub, pkg-config, meson, ninja, c-stdaux }:

stdenv.mkDerivation rec {
  pname = "c-list";
  version = "unstable-2022-05-03";

  nativeBuildInputs = [ meson ninja pkg-config c-stdaux ];

  src = fetchFromGitHub {
    owner = "c-util";
    repo = "c-list";
    rev = "b86ba656ac22b00fe785b2f058123e807f97c109";
    sha256 = "1kb99ws6kkpbc08g32n4sb4pmga7ahlgmlhy254wc32yx7gsxla0";
  };

  meta = with lib; {
    description = "Common Utility Libraries for C11";
    homepage    = "https://c-util.github.io/c-list/";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ xaverdh ];
  };
}
