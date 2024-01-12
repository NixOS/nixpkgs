{ lib, stdenv, fetchFromGitHub, evdev-proto, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libudev-devd";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "wulf7";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HQn74D27hOxPMWJb5UoLJk9FSp0zdfCdQ7zM2/oItZY=";
  };

  buildInputs = [ evdev-proto ];
  nativeBuildInputs = [ autoreconfHook ];

  env = {
    CFLAGS = "-Wno-error=array-parameter";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/wulf7/libudev-devd";
    description = "libudev-compatible interface for devd";
    maintainers = with maintainers; [ rhelmot ];
    license = licenses.bsd2;
    platforms = platforms.freebsd;
  };
}
