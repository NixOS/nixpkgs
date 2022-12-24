{ lib
, pkgs
, stdenv
, fetchFromGitLab
, cmake
, extra-cmake-modules
, gobject-introspection
, pcre2
, lttng-ust
, json-glib
, zeitgeist
, lomiri-click
}:

stdenv.mkDerivation rec {
  pname = "lomiri-app-launch";
  version = "unstable-2022-12-12";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "ubports";
    repo = "development/core/lomiri-app-launch";
    rev = "4ed38ca23627e1d07626b3bb4b2c62115f3d3354";
    sha256 = "sha256-x06mNCg+xlekcAn2GYJ/XJZow1iFPrbIJWwwv39BR04=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    gobject-introspection
    pcre2
    lttng-ust
    json-glib
    zeitgeist
    lomiri-click
  ];

  cmakeFlags = [
    "-DLOMIRI_APP_LAUNCH_ARCH=x86_64-linux-gnu"
  ];

  meta = with lib; {
    description = "Session init system job for launching applications";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-app-launch";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ onny ];
  };

}
