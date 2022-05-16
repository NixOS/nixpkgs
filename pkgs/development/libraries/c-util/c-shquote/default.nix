{ lib, stdenv, fetchFromGitHub, pkg-config, meson, ninja, c-stdaux }:

stdenv.mkDerivation rec {
  pname = "c-shquote";
  version = "unstable-2022-05-12";

  nativeBuildInputs = [ meson ninja pkg-config c-stdaux ];

  src = fetchFromGitHub {
    owner = "c-util";
    repo = "c-shquote";
    rev = "8b82a8cf51b6b85ae343e2e7842edd06b8cb0798";
    sha256 = "1v56zxdyxhchz5j34kizkcp2aifa31p5a5w4qshimgk2d5bkf6jq";
  };

  meta = with lib; {
    description = "Common Utility Libraries for C11";
    homepage    = "https://c-util.github.io/c-shquote/";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ xaverdh ];
  };
}
