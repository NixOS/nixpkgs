{ stdenv, fetchFromGitHub
, cmake, cmake-extras
, gobject-introspection, lttng-ust, json-glib, zeitgeist, dbus, dbus-test-runner, mir_1, curl, unity-api, gtest, gmock, properties-cpp
}:

stdenv.mkDerivation rec {
  pname = "ubuntu-app-launch-unstable";
  version = "2018-11-03";

  src = fetchFromGitHub {
    owner = "ubports";
    repo = "ubuntu-app-launch";
    # current branch to follow is "bionic_-_libertine-optional"
    rev = "456c701bb221fd01fce95ece7f653076bda3ade7";
    sha256 = "1cvy4q4r7p94615l8kbdsbhcjwisxd3aq767iydqa867cf1blrgx";
  };

  postPatch = ''
    substituteInPlace tests/CMakeLists.txt \
      --replace '$''\{GMOCK_LIBRARIES}' '$''\{GTEST_BOTH_LIBRARIES} $''\{GMOCK_LIBRARIES}'
  '';

  nativeBuildInputs = [ cmake cmake-extras ];

  buildInputs = [ gobject-introspection lttng-ust json-glib zeitgeist dbus dbus-test-runner mir_1 curl unity-api gtest gmock properties-cpp ];

  cmakeFlags = [
    "-DCMAKE_C_FLAGS=-Wno-error=deprecated-declarations"
    "-DCMAKE_CXX_FLAGS=-Wno-error=deprecated-declarations"
  ];

  meta = with stdenv.lib; {
    description = "Session init system job for Launching Applications";
    longDescription = ''
      Upstart Job file and associated utilities that is used to launch
      applications in a standard and confined way.
    '';
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.linux;
  };
}
