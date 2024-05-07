{ lib
, stdenv
, fetchFromGitHub
, cmake
, libXdmcp
, libexif
, libfm
, libpthreadstubs
, libxcb
, lxqt-build-tools
, lxqt-menu-data
, menu-cache
, pcre
, pkg-config
, qttools
, wrapQtAppsHook
, gitUpdater
, version ? "2.0.1"
, qtx11extras ? null
}:

stdenv.mkDerivation rec {
  pname = "libfm-qt";
  inherit version;

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "libfm-qt";
    rev = version;
    hash = {
      "1.4.0" = "sha256-QxPYSA7537K+/dRTxIYyg+Q/kj75rZOdzlUsmSdQcn4=";
      "2.0.1" = "sha256-iU55tUjN01+hTHTM6784OxoAiK6SbsSnUXHTL56iIF0=";
    }."${version}";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    lxqt-build-tools
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    libXdmcp
    libexif
    libfm
    libpthreadstubs
    libxcb
    lxqt-menu-data
    menu-cache
    pcre
  ] ++ (lib.optionals (lib.versionAtLeast "2.0.0" version) [qtx11extras])
  ;

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/libfm-qt";
    description = "Core library of PCManFM-Qt (Qt binding for libfm)";
    license = licenses.lgpl21Plus;
    platforms = with platforms; unix;
    maintainers = teams.lxqt.members;
  };
}
