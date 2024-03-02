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
  version = "2.0.2+date=2023-04-30";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = "f47c36f5bd2a653a3bd7fb1cf1d2c50b0e6193fb";
    hash = "sha256-ojFnFD0lcdJLP27oFukwzkG5THx1QE+tRBsaMj4ZCc4=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libplist
    libimobiledevice-glue
  ];

  preAutoreconf = ''
    export RELEASE_VERSION=${version}
  '';

  meta = with lib; {
    description = "A client library to multiplex connections from and to iOS devices";
    homepage = "https://github.com/libimobiledevice/libusbmuxd";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ infinisil ];
  };
}
