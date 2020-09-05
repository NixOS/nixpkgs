{ stdenv
, fetchFromGitHub
, meson
, ninja
, pkgconfig
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
    pkgconfig
  ];

  meta = with stdenv.lib; {
    description = "Minimal mDNS resolver library, used by VLC";
    homepage = "https://github.com/videolabs/libmicrodns";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = [ maintainers.shazow ];
  };
}
