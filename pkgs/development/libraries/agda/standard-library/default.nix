{
  lib,
  mkDerivation,
  fetchFromGitHub,
  nixosTests,
}:

mkDerivation rec {
  pname = "standard-library";
  version = "2.3";

  src = fetchFromGitHub {
    repo = "agda-stdlib";
    owner = "agda";
    rev = "v${version}";
    hash = "sha256-V3EbpqkZK/yfGxLBntKTJO9kqqQogWYPStsQSdDyeLc=";
  };

  passthru.tests = { inherit (nixosTests) agda; };
  meta = with lib; {
    homepage = "https://wiki.portal.chalmers.se/agda/pmwiki.php?n=Libraries.StandardLibrary";
    description = "Standard library for use with the Agda compiler";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with maintainers; [
      jwiegley
      mudri
      alexarice
      turion
    ];
  };
}
