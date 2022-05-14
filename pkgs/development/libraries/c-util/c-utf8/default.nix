{ lib, stdenv, fetchFromGitHub, pkg-config, meson, ninja, c-stdaux }:

stdenv.mkDerivation rec {
  pname = "c-utf8";
  version = "unstable-2022-05-03";

  nativeBuildInputs = [ meson ninja pkg-config c-stdaux ];

  src = fetchFromGitHub {
    owner = "c-util";
    repo = "c-utf8";
    rev = "314559cb9c63a2d9ac420669bc1b5aca7ad0dcf5";
    sha256 = "18yvjxz3f7n15aicwwcsi099mgzp8f9vacpiywxlmflmzxaz13vi";
  };

  meta = with lib; {
    description = "Common Utility Libraries for C11";
    homepage    = "https://c-util.github.io/c-utf8/";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ xaverdh ];
  };
}
