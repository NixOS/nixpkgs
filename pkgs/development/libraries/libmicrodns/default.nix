{ stdenv
, fetchFromGitHub
, autoreconfHook
, pkgconfig
}:

stdenv.mkDerivation rec {
  version = "0.0.10";
  pname = "libmicrodns";

  src = fetchFromGitHub {
    owner = "videolabs";
    repo = pname;
    rev = version;
    sha256 = "1xvl9k49ng35wbsqmnjnyqvkyjf8dcq2ywsq3jp3wh0rgmxhq2fh";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
  ];

  meta = with stdenv.lib; {
    description = "Minimal mDNS resolver library, used by VLC";
    homepage = https://github.com/videolabs/libmicrodns;
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = [ maintainers.shazow ];
  };
}
