{ lib, stdenv, fetchFromGitHub, cmake, glib, pkg-config }:

stdenv.mkDerivation rec {
  pname = "lcm";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "lcm-proj";
    repo = "lcm";
    rev = "v${version}";
    hash = "sha256-ujz52m7JuE5DYGM9QHLwVWVVBcny4w05J6Eu6DI2HBI=";
  };

  outputs = [ "out" "dev" "man" ];

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    glib
  ];

  meta = with lib; {
    description = "Lightweight Communications and Marshalling (LCM)";
    homepage = "https://github.com/lcm-proj/lcm";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ kjeremy ];
    platforms = lib.platforms.unix;
  };
}
