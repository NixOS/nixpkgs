{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "arc-kde-theme";
  version = "20220810";

  src = fetchFromGitHub {
    owner = "PapirusDevelopmentTeam";
    repo = "arc-kde";
    rev = version;
    sha256 = "sha256-atL0sW3AedQl7PabOQOjeJ5U8a4/J4x0rxFCbxJ4ONA=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  # Make this a fixed-output derivation
  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  ouputHash = "2c2def57092a399aa1c450699cbb8639f47d751157b18db17";

  meta = {
    description = "A port of the arc theme for Plasma";
    homepage = "https://git.io/arc-kde";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.nixy ];
    platforms = lib.platforms.all;
  };
}
