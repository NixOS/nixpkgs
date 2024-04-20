{ lib, stdenv, fetchFromGitHub, pkg-config, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libuev";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "libuev";
    rev = "v${version}";
    hash = "sha256-x1Sk7IuhlBQPFL7Rq4tmEanBxI/WaQ2L5fpUyEWOoi8=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];

  meta = with lib; {
    description = "Lightweight event loop library for Linux epoll() family APIs";
    homepage = "https://codedocs.xyz/troglobit/libuev/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ vifino ];
  };
}
