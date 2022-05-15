{ lib, stdenv, fetchFromGitHub, pkg-config, meson, ninja, c-stdaux }:

stdenv.mkDerivation rec {
  pname = "c-rbtree";
  version = "unstable-2022-05-03";

  nativeBuildInputs = [ meson ninja pkg-config c-stdaux ];

  src = fetchFromGitHub {
    owner = "c-util";
    repo = "c-rbtree";
    rev = "9b9713aeb9eca98566a85c8c90a02942ea430819";
    sha256 = "0wd6jjwv0rvhg7ficyzj6xbcirkcz2a3msax6pinj1n65bf2574g";
  };

  meta = with lib; {
    description = "Common Utility Libraries for C11";
    homepage    = "https://c-util.github.io/c-rbtree/";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ xaverdh ];
  };
}
