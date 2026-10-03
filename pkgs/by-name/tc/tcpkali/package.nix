{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  bison,
}:

let
  version = "1.1.1";
in

stdenv.mkDerivation rec {
  pname = "tcpkali";
  inherit version;
  src = fetchFromGitHub {
    owner = "machinezone";
    repo = "tcpkali";
    rev = "v${version}";
    hash = "sha256-rtMI18IUovjA3MVdwX7Viqak7wVAO2gNwwxexRgbfiY=";
  };
  postPatch = ''
    sed -i -e '/sys\/sysctl\.h/d' src/tcpkali_syslimits.c
  '';
  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ bison ];
  meta = {
    description = "High performance TCP and WebSocket load generator and sink";
    license = lib.licenses.bsd2;
    inherit (src.meta) homepage;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "tcpkali";
  };
}
