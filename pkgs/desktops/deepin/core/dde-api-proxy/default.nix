{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libsForQt5,
  dtkcore,
  coreutils,
}:

stdenv.mkDerivation rec {
  pname = "dde-api-proxy";
  version = "1.0.20";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "dde-api-proxy";
    rev = version;
    hash = "sha256-QE31BOh2LFlY6te+2+nSHGbhLsikSX8V7xSvcLzCWRA=";
  };

  postPatch = ''
    for file in $(grep -rl "/usr/bin/false"); do
      substituteInPlace $file --replace-fail "/usr/bin/false" "${coreutils}/bin/false"
    done
    for file in $(grep -rl "/usr/lib/dde-api-proxy"); do
      substituteInPlace $file --replace-fail "/usr/lib/dde-api-proxy" "$out/lib/dde-api-proxy"
    done
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    dtkcore
    libsForQt5.qtbase
    libsForQt5.polkit-qt
  ];

  meta = {
    description = "Proxy service for dde";
    homepage = "https://github.com/linuxdeepin/dde-api-proxy";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = lib.teams.deepin.members;
  };
}
