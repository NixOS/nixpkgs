{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, libplist
, libimobiledevice-glue
}:

stdenv.mkDerivation rec {
  pname = "libusbmuxd";
  version = "2.0.2+date=2022-05-04";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = "36ffb7ab6e2a7e33bd1b56398a88895b7b8c615a";
    hash = "sha256-41N5cSLAiPJ9FjdnCQnMvPu9/qhI3Je/M1VmKY+yII4=";
  };

  postPatch = ''
    echo '${version}' > .tarball-version
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libplist
    libimobiledevice-glue
  ];

  meta = with lib; {
    description = "A client library to multiplex connections from and to iOS devices";
    homepage = "https://github.com/libimobiledevice/libusbmuxd";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ infinisil ];
  };
}
