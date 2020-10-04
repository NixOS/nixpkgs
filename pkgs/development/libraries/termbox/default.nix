{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "termbox";
  version = "1.1.3";
  src = fetchFromGitHub {
    owner = "termbox";
    repo = "termbox";
    rev = "v${version}";
    sha256 = "08sq5n9l9zcrbkjvqyl1gqd57yaz9jh291fwfcwdfdjb4a8zhd17";
  };

  makeFlags = [ "prefix=${placeholder "out"}" ];

  meta = with stdenv.lib; {
    description = "Library for writing text-based user interfaces";
    license = licenses.mit;
    homepage = "https://github.com/termbox/termbox#readme";
    downloadPage = "https://github.com/termbox/termbox/releases";
    maintainers = with maintainers; [ fgaz ];
  };
}
