{ lib, stdenv, fetchFromGitHub, cmake, glib, pkg-config }:

stdenv.mkDerivation rec {
  pname = "lcm";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "lcm-proj";
    repo = "lcm";
    rev = "v${version}";
    hash = "sha256-IFHoJl5OtnUb+w3gLG5f578yAektjgrY9Uj2eUVoIrc=";
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
