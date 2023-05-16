{ lib, stdenv, fetchFromGitHub
, meson, ninja, pkg-config, cmake
, libtirpc, rpcsvc-proto, avahi, libxml2
}:

stdenv.mkDerivation rec {
  pname = "liblxi";
<<<<<<< HEAD
  version = "1.20";
=======
  version = "1.19";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "lxi-tools";
    repo = "liblxi";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-jS0huNkbyKrsJ3NkenrYtjkzLakOsTJpwlgSo98ribE=";
=======
    sha256 = "sha256-TdIUPAXBogGT9OQrX4wkSmPFjR9McdS9gnQ7c24U4qs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ meson ninja cmake pkg-config rpcsvc-proto ];

<<<<<<< HEAD
  buildInputs = lib.optionals (!stdenv.isDarwin) [
    libtirpc
    avahi
  ] ++ [
    libxml2
  ];
=======
  buildInputs = [ libtirpc avahi libxml2 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Library for communicating with LXI compatible instruments";
    longDescription = ''
      liblxi is an open source software library which offers a simple
      API for communicating with LXI compatible instruments.
      The API allows applications to easily discover instruments
      on networks and communicate SCPI commands.
    '';
    homepage = "https://lxi-tools.github.io/";
    license = licenses.bsd3;
<<<<<<< HEAD
    platforms = platforms.unix;
=======
    platforms = platforms.linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = [ maintainers.vq ];
  };
}
