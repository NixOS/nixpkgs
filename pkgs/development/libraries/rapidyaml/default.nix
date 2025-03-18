{ lib
, stdenv
, cmake
, fetchFromGitHub
, git
}:

stdenv.mkDerivation rec {
  pname = "rapidyaml";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "biojppm";
    repo = pname;
    fetchSubmodules = true;
    rev = "v${version}";
    hash = "sha256-VpREG75d+Rmfu8B2VTWueJtfEZwKxGUFb8E3OwVy1L4=";
  };

  nativeBuildInputs = [ cmake git ];

  meta = with lib; {
    description = "Library to parse and emit YAML, and do it fast";
    homepage = "https://github.com/biojppm/rapidyaml";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
