{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libplist }:

stdenv.mkDerivation rec {
  pname = "libusbmuxd";
  version = "2019-01-18";

  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = "c75605d862cd1c312494f6c715246febc26b2e05";
    sha256 = "0467a045k4znmaz61i7a2s7yywj67q830ja6zn7z39k5pqcl2z4p";
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
