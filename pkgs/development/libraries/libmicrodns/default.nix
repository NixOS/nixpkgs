{ stdenv
, fetchFromGitHub
, meson
, ninja
, pkgconfig
}:

stdenv.mkDerivation rec {
  version = "0.1.2";
  pname = "libmicrodns";

  src = fetchFromGitHub {
    owner = "videolabs";
    repo = pname;
    rev = version;
    sha256 = "1yb0j0acidp494d28wqhzhrfski2qjb2a5mp5bq5qrpcg38zyz6i";
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
