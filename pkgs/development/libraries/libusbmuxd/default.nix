{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libplist }:

stdenv.mkDerivation rec {
  pname = "libusbmuxd";
  version = "2018-07-23";

  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = "78df9be5fc8222ed53846cb553de9b5d24c85c6c";
    sha256 = "05hbn0mbmv5ln9hfsvnf7i1mnp6ncbyfnl5w331kg4fi12wjshc5";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libplist ];

  meta = with stdenv.lib; {
    description = "A client library to multiplex connections from and to iOS devices";
    homepage    = https://github.com/libimobiledevice/libusbmuxd;
    license     = licenses.lgpl21Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
