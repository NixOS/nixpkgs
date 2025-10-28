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
    hash = "sha256-JOeoek6OfyIk9vwTj5QUJU6LnRzwfiG0e0ysW6zbhZ8=";
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
