{ lib, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
}:

stdenv.mkDerivation rec {
  version = "0.2.0";
  pname = "libmicrodns";

  src = fetchFromGitHub {
    owner = "videolabs";
    repo = pname;
    rev = version;
    sha256 = "05vgka45c1frnv4q7pbz0bggsn5xaykh4xpklh9yb6d6qj7dbx0b";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  meta = with lib; {
    description = "Minimal mDNS resolver library, used by VLC";
    homepage = "https://github.com/videolabs/libmicrodns";
    license = licenses.lgpl21;
    platforms = platforms.unix;
    maintainers = [ maintainers.shazow ];
  };
}
