{ lib
, stdenv
, fetchFromGitHub
, cmake
<<<<<<< HEAD
, expat
, pkg-config
, systemd
=======
, pkg-config
, systemd
, expat
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "sdbus-cpp";
<<<<<<< HEAD
  version = "1.3.0";
=======
  version = "1.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "kistler-group";
    repo = "sdbus-cpp";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-S/8/I2wmWukpP+RGPxKbuO44wIExzeYZL49IO+KOqg4=";
=======
    sha256 = "sha256-EX/XLgqUwIRosLu3Jgtpp42Yt6Tf22Htj9JULoUL7ao=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
<<<<<<< HEAD
    expat
    systemd
=======
    systemd
    expat
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  cmakeFlags = [
    "-DBUILD_CODE_GEN=ON"
  ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    homepage = "https://github.com/Kistler-Group/sdbus-cpp";
    changelog = "https://github.com/Kistler-Group/sdbus-cpp/blob/v${version}/ChangeLog";
    description = "High-level C++ D-Bus library designed to provide easy-to-use yet powerful API";
    longDescription = ''
<<<<<<< HEAD
      sdbus-c++ is a high-level C++ D-Bus library for Linux designed to provide
      expressive, easy-to-use API in modern C++.
      It adds another layer of abstraction on top of sd-bus, a nice, fresh C
      D-Bus implementation by systemd.
      It's been written primarily as a replacement of dbus-c++, which currently
      suffers from a number of (unresolved) bugs, concurrency issues and
      inherent design complexities and limitations.
    '';
    license = lib.licenses.lgpl2Only;
    maintainers = [ lib.maintainers.ivar ];
    platforms = lib.platforms.linux;
    mainProgram = "sdbus-c++-xml2cpp";
=======
      sdbus-c++ is a high-level C++ D-Bus library for Linux designed to provide expressive, easy-to-use API in modern C++.
      It adds another layer of abstraction on top of sd-bus, a nice, fresh C D-Bus implementation by systemd.
      It's been written primarily as a replacement of dbus-c++, which currently suffers from a number of (unresolved) bugs,
      concurrency issues and inherent design complexities and limitations.
    '';
    mainProgram = "sdbus-c++-xml2cpp";
    license = licenses.lgpl2Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.ivar ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
