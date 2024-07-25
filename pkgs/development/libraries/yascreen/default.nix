{ lib, stdenv, go-md2man, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "yascreen";
  version = "1.86";

  src = fetchFromGitHub {
    owner = "bbonev";
    repo = "yascreen";
    rev = "v${version}";
    sha256 = "sha256-z7j2yceiUyJNdyoVXAPiINln2/MUMqVJh+VwQnmzO2A=";
  };

  nativeBuildInputs = [ go-md2man ];
  makeFlags = [ "PREFIX=$(out)" ];

  patches = [
    (fetchpatch {
      url = "https://github.com/bbonev/yascreen/commit/a30b8fce66a3db9f1194fede30a48424ed3d696b.patch";
      sha256 = "sha256-Bnaf3OVMlqyYMdGsJ6fF3oYsWT01FcjuRzxi6xfbnZg=";
    })
  ];

  meta = with lib; {
    homepage = "https://github.com/bbonev/yascreen";
    description = "Yet Another Screen Library (curses replacement for daemons and embedded apps)";
    license = licenses.lgpl3;
    maintainers = [ maintainers.arezvov ];
    platforms = platforms.linux;
  };
}
