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
  libxml2,
  python3,
  valgrind,
}:

stdenv.mkDerivation rec {
  pname = "libwacom";
  version = "2.11.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "linuxwacom";
    repo = "libwacom";
    rev = "libwacom-${version}";
    hash = "sha256-TQOe954Zos3VpAG5M/O5je9dr8d4gOXIwy4xl3o+e1g=";
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
  ];

  checkInputs = [
    libxml2
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
