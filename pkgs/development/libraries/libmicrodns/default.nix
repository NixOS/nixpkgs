{ stdenv
, fetchFromGitHub
, autoreconfHook
, pkgconfig
}:

stdenv.mkDerivation rec {
  version = "0.1.0";
  pname = "libmicrodns";

  src = fetchFromGitHub {
    owner = "videolabs";
    repo = pname;
    rev = version;
    sha256 = "1pmf461zn35spbpbls1ih68ki7f8g8xjwhzr2csy63nnyq2k9jji";
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
