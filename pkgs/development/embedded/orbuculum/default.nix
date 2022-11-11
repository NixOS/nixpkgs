{ lib
, stdenv
, fetchFromGitHub
, czmq
, libusb1
, ncurses
}:

stdenv.mkDerivation rec {
  pname = "orbuculum";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "orbcode";
    repo = pname;
    rev = "V${version}";
    sha256 = "sha256-aMMXfrBQQ9oOx17MUKmqe5vdTpxhBGM5mVfAel0y0a0=";
  };

  buildInputs = [
    czmq
    libusb1
    ncurses
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
