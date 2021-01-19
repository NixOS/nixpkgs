{ stdenv, fetchFromGitHub, autoreconfHook, pkg-config, libplist }:

stdenv.mkDerivation rec {
  pname = "libusbmuxd";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = version;
    sha256 = "139pzsnixkck6ly1q6p0diqr0hgd0mx0pr4xx1jamm3f3656kpf9";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libplist ];

  meta = with stdenv.lib; {
    description = "A client library to multiplex connections from and to iOS devices";
    homepage    = "https://github.com/libimobiledevice/libusbmuxd";
    license     = licenses.lgpl21Plus;
    platforms   = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ infinisil ];
  };
}
