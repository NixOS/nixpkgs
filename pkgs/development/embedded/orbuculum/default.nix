{ lib
, stdenv
, fetchFromGitHub
<<<<<<< HEAD
, meson
, ninja
, pkg-config
, czmq
, libusb1
, ncurses
, SDL2
=======
, czmq
, libusb1
, ncurses
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "orbuculum";
<<<<<<< HEAD
  version = "2.1.0";
=======
  version = "2.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "orbcode";
    repo = pname;
    rev = "V${version}";
<<<<<<< HEAD
    sha256 = "sha256-Ohcc8739W/EmDjOYhcMgzEPVhzbWrUYgsPLdy4qzxhY=";
  };

  prePatch = ''
    substituteInPlace meson.build --replace \
      "/etc/udev/rules.d" "$out/etc/udev/rules.d"
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

=======
    sha256 = "sha256-aMMXfrBQQ9oOx17MUKmqe5vdTpxhBGM5mVfAel0y0a0=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildInputs = [
    czmq
    libusb1
    ncurses
<<<<<<< HEAD
    SDL2
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  installFlags = [
    "INSTALL_ROOT=$(out)/"
  ];

  postInstall = ''
    mkdir -p $out/etc/udev/rules.d/
    cp $src/Support/60-orbcode.rules $out/etc/udev/rules.d/
  '';

  meta = with lib; {
    description = "Cortex M SWO SWV Demux and Postprocess for the ORBTrace";
    homepage = "https://orbcode.org";
    changelog = "https://github.com/orbcode/orbuculum/blob/V${version}/CHANGES.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ newam ];
    platforms = platforms.linux;
  };
}
