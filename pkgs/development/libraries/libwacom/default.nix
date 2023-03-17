{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, glib
, pkg-config
, udev
, libgudev
, python3
, valgrind
}:

stdenv.mkDerivation rec {
  pname = "libwacom";
  version = "2.6.0";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "linuxwacom";
    repo = "libwacom";
    rev = "libwacom-${version}";
    sha256 = "sha256-9zqW6zPrFcxv/yAAtFgdVavKVMXeDBoMP3E/XriUcT0=";
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
    libgudev
  ];

  doCheck = stdenv.hostPlatform == stdenv.buildPlatform;

  mesonFlags = [
    "-Dtests=${if doCheck then "enabled" else "disabled"}"
  ];

  nativeCheckInputs = [
    valgrind
  ] ++ (with python3.pkgs; [
    libevdev
    pytest
    pyudev
  ]);

  meta = with lib; {
    platforms = platforms.linux;
    homepage = "https://linuxwacom.github.io/";
    changelog = "https://github.com/linuxwacom/libwacom/blob/${src.rev}/NEWS";
    description = "Libraries, configuration, and diagnostic tools for Wacom tablets running under Linux";
    maintainers = teams.freedesktop.members;
    license = licenses.mit;
  };
}
