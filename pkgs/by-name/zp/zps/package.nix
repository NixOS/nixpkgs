{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "zps";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "zps";
    rev = version;
    hash = "sha256-t+y+m9cwngVlX5o7FQTI4FMj10bN0euH51DmAnOAvPc=";
  };

  nativeBuildInputs = [
    cmake
  ];

  postInstall = ''
    mkdir -p $out/share/applications
    substitute ../.application/zps.desktop $out/share/applications/zps.desktop \
      --replace Exec=zps Exec=$out/zps \
  '';

  meta = {
    description = "Small utility for listing and reaping zombie processes on GNU/Linux";
    homepage = "https://github.com/orhun/zps";
    changelog = "https://github.com/orhun/zps/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "zps";
  };
}
