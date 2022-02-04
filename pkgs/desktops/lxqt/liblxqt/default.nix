{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, lxqt-build-tools
, qtx11extras
, qttools
, qtsvg
, libqtxdg
, polkit-qt
, kwindowsystem
, xorg
, lxqtUpdateScript
}:

mkDerivation rec {
  pname = "liblxqt";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "08cqvq99pvz8lz13273hlpv8160r6zyz4f7h4kl1g8xdga7m45gr";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  buildInputs = [
    qtx11extras
    qttools
    qtsvg
    polkit-qt
    kwindowsystem
    libqtxdg
    xorg.libXScrnSaver
  ];

  # convert name of wrapped binary, e.g. .lxqt-whatever-wrapped to the original name, e.g. lxqt-whatever so binaries can find their resources
  patches = [ ./fix-application-path.patch ];

  postPatch = ''
    # https://github.com/NixOS/nixpkgs/issues/119766
    substituteInPlace lxqtbacklight/linux_backend/driver/libbacklight_backend.c \
      --replace "pkexec lxqt-backlight_backend" "pkexec $out/bin/lxqt-backlight_backend"

    sed -i "s|\''${POLKITQT-1_POLICY_FILES_INSTALL_DIR}|''${out}/share/polkit-1/actions|" CMakeLists.txt
  '';

  passthru.updateScript = lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    description = "Core utility library for all LXQt components";
    homepage = "https://github.com/lxqt/liblxqt";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
