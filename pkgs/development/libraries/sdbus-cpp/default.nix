{ lib
, stdenv
, fetchFromGitHub
, cmake
, expat
, pkg-config
, systemd
}:

stdenv.mkDerivation rec {
  pname = "sdbus-cpp";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "kistler-group";
    repo = "sdbus-cpp";
    rev = "v${version}";
    hash = "sha256-S/8/I2wmWukpP+RGPxKbuO44wIExzeYZL49IO+KOqg4=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    expat
    systemd
  ];

  cmakeFlags = [
    "-DBUILD_CODE_GEN=ON"
  ];

  meta = {
    homepage = "https://github.com/Kistler-Group/sdbus-cpp";
    changelog = "https://github.com/Kistler-Group/sdbus-cpp/blob/v${version}/ChangeLog";
    description = "High-level C++ D-Bus library designed to provide easy-to-use yet powerful API";
    longDescription = ''
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
  };
}
