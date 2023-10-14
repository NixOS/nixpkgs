{ lib, stdenv, fetchFromGitHub, pkg-config, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libuev";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "libuev";
    rev = "v${version}";
    hash = "sha256-x6l7CqlZ82kc8shAf2SxgIa4ESu0fTtnOgGz5joVCEY=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];

  meta = with lib; {
    description = "Lightweight event loop library for Linux epoll() family APIs";
    homepage = "https://codedocs.xyz/troglobit/libuev/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ vifino ];
  };
}
