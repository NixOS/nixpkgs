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
<<<<<<< HEAD
  version = "2.7.0";
=======
  version = "2.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "linuxwacom";
    repo = "libwacom";
    rev = "libwacom-${version}";
<<<<<<< HEAD
    sha256 = "sha256-NNfhZMshM5U/EfJHuNgkDe5NEkEGKtJ56vSpXyGf/xw=";
=======
    sha256 = "sha256-9zqW6zPrFcxv/yAAtFgdVavKVMXeDBoMP3E/XriUcT0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  doCheck = stdenv.hostPlatform == stdenv.buildPlatform && lib.meta.availableOn stdenv.hostPlatform valgrind;
=======
  doCheck = stdenv.hostPlatform == stdenv.buildPlatform;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
