{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  glib,
  pkg-config,
  udev,
  libevdev,
  libgudev,
  python3,
  valgrind,
}:

stdenv.mkDerivation rec {
  pname = "libwacom";
  version = "2.12.2";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "linuxwacom";
    repo = "libwacom";
    rev = "libwacom-${version}";
    hash = "sha256-dxnXh+O/8q8ShsPbpqvaBPNQR6lJBphBolYTmcJEF/0=";
  };

  postPatch = ''
    patchShebangs test/check-files-in-git.sh
  '';

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    python3
  ];

  buildInputs = [
    glib
    udev
    libevdev
    libgudev
  ];

  doCheck =
    stdenv.hostPlatform == stdenv.buildPlatform
    && lib.meta.availableOn stdenv.hostPlatform valgrind
    && !stdenv.hostPlatform.isPower # one test times out
  ;

  mesonFlags = [
    "-Dtests=${if doCheck then "enabled" else "disabled"}"
    "--sysconfdir=/etc"
  ];

  nativeCheckInputs = [
    valgrind
    (python3.withPackages (
      ps: with ps; [
        ps.libevdev
        pytest
        pyudev
      ]
    ))
  ];

  meta = with lib; {
    platforms = platforms.linux;
    homepage = "https://linuxwacom.github.io/";
    changelog = "https://github.com/linuxwacom/libwacom/blob/${src.rev}/NEWS";
    description = "Libraries, configuration, and diagnostic tools for Wacom tablets running under Linux";
    maintainers = teams.freedesktop.members;
    license = licenses.hpnd;
  };
}
