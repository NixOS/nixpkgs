{
  lib,
  mkDerivation,
  fetchFromGitHub,
  nixosTests,
}:

mkDerivation rec {
  pname = "standard-library";
  version = "2.4";

  src = fetchFromGitHub {
    repo = "agda-stdlib";
    owner = "agda";
    rev = "v${version}";
    hash = "sha256-cnYKW/KRKVsTBupQo1DNnH5Cx7sh6W+NEsZPHRWIBjE=";
  };

  passthru.tests = { inherit (nixosTests) agda; };
  meta = {
    homepage = "https://wiki.portal.chalmers.se/agda/pmwiki.php?n=Libraries.StandardLibrary";
    description = "Standard library for use with the Agda compiler";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      jwiegley
      mudri
      alexarice
      turion
    ];
  };
}
