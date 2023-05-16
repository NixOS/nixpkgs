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
<<<<<<< HEAD
  version = "2.0.2+date=2023-04-30";
=======
  version = "2.0.2+date=2022-05-04";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
<<<<<<< HEAD
    rev = "f47c36f5bd2a653a3bd7fb1cf1d2c50b0e6193fb";
    hash = "sha256-ojFnFD0lcdJLP27oFukwzkG5THx1QE+tRBsaMj4ZCc4=";
  };

=======
    rev = "36ffb7ab6e2a7e33bd1b56398a88895b7b8c615a";
    hash = "sha256-41N5cSLAiPJ9FjdnCQnMvPu9/qhI3Je/M1VmKY+yII4=";
  };

  postPatch = ''
    echo '${version}' > .tarball-version
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libplist
    libimobiledevice-glue
  ];

<<<<<<< HEAD
  preAutoreconf = ''
    export RELEASE_VERSION=${version}
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "A client library to multiplex connections from and to iOS devices";
    homepage = "https://github.com/libimobiledevice/libusbmuxd";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ infinisil ];
  };
}
