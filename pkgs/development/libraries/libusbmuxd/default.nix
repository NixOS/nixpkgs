{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libplist }:

stdenv.mkDerivation rec {
  pname = "libusbmuxd";
  version = "2019-03-23";

  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = "873252dc8b4e469c7dc692064ac616104fca5f65";
    sha256 = "0qx3q0n1f2ajfm3vnairikayzln6iyb2y0i7sqfl8mj45ahl6wyj";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libplist ];

  meta = with stdenv.lib; {
    description = "A client library to multiplex connections from and to iOS devices";
    homepage    = https://github.com/libimobiledevice/libusbmuxd;
    license     = licenses.lgpl21Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ infinisil ];
  };
}
