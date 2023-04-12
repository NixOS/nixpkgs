{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, systemd
, expat
}:

stdenv.mkDerivation rec {
  pname = "sdbus-cpp";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "kistler-group";
    repo = "sdbus-cpp";
    rev = "v${version}";
    sha256 = "sha256-EX/XLgqUwIRosLu3Jgtpp42Yt6Tf22Htj9JULoUL7ao=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    systemd
    expat
  ];

  cmakeFlags = [
    "-DBUILD_CODE_GEN=ON"
  ];

  meta = with lib; {
    homepage = "https://github.com/Kistler-Group/sdbus-cpp";
    changelog = "https://github.com/Kistler-Group/sdbus-cpp/blob/v${version}/ChangeLog";
    description = "High-level C++ D-Bus library designed to provide easy-to-use yet powerful API";
    longDescription = ''
      sdbus-c++ is a high-level C++ D-Bus library for Linux designed to provide expressive, easy-to-use API in modern C++.
      It adds another layer of abstraction on top of sd-bus, a nice, fresh C D-Bus implementation by systemd.
      It's been written primarily as a replacement of dbus-c++, which currently suffers from a number of (unresolved) bugs,
      concurrency issues and inherent design complexities and limitations.
    '';
    mainProgram = "sdbus-c++-xml2cpp";
    license = licenses.lgpl2Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.ivar ];
  };
}
