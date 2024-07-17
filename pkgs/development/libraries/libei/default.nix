{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchFromGitLab,
  libevdev,
  libxkbcommon,
  meson,
  ninja,
  pkg-config,
  protobuf,
  protobufc,
  systemd,
  buildPackages,
}:
let
  munit = fetchFromGitHub {
    owner = "nemequ";
    repo = "munit";
    rev = "fbbdf1467eb0d04a6ee465def2e529e4c87f2118";
    hash = "sha256-qm30C++rpLtxBhOABBzo+6WILSpKz2ibvUvoe8ku4ow=";
  };
in
stdenv.mkDerivation rec {
  pname = "libei";
  version = "1.2.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "libinput";
    repo = "libei";
    rev = version;
    hash = "sha256-8n/C0rBlyhY8SaxkwU+tDskwSQObLRrR+utk4Ktgb7U=";
  };

  buildInputs = [
    libevdev
    libxkbcommon
    protobuf
    protobufc
    systemd
  ];
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    (buildPackages.python3.withPackages (
      ps: with ps; [
        attrs
        jinja2
        pytest
        python-dbusmock
        strenum
        structlog
      ]
    ))
  ];

  postPatch = ''
    ln -s "${munit}" ./subprojects/munit
    patchShebangs ./proto/ei-scanner
  '';

  meta = with lib; {
    description = "Library for Emulated Input";
    mainProgram = "ei-debug-events";
    homepage = "https://gitlab.freedesktop.org/libinput/libei";
    license = licenses.mit;
    maintainers = [ maintainers.pedrohlc ];
    platforms = platforms.linux;
  };
}
