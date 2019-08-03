{stdenv, fetchpatch, autoconf, automake, fetchFromGitHub, pkgconfig}:

let
  pname = "mypaint-brushes";
  version = "1.3.0";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "Jehan";
    repo = pname;
    rev = "v${version}";
    sha256 = "1iz89z6v2mp8j1lrf942k561s8311i3s34ap36wh4rybb2lq15m0";
  };

  nativeBuildInputs = [ autoconf automake pkgconfig ];

  patches = [
    # build with automake 1.16
    (fetchpatch {
      url = https://github.com/Jehan/mypaint-brushes/commit/1e9109dde3bffd416ed351c3f30ecd6ffd0ca2cd.patch;
      sha256 = "0mi8rwbirl0ib22f2hz7kdlgi4hw8s3ab29b003dsshdyzn5iha9";
    })
  ];

  preConfigure = "./autogen.sh";

  meta = with stdenv.lib; {
    homepage = http://mypaint.org/;
    description = "Brushes used by MyPaint and other software using libmypaint.";
    license = licenses.cc0;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
