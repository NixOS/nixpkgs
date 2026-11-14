{
  lib,
  fetchurl,
  buildDunePackage,
}:

buildDunePackage (finalAttrs: {
  pname = "windtrap";
  version = "0.3.1";
  minimalOCamlVersion = "5.0";

  src = fetchurl {
    url = "https://github.com/invariant-hq/windtrap/releases/download/v${finalAttrs.version}/windtrap-${finalAttrs.version}.tbz";
    hash = "sha256-mox5Jsd7HCWAEOAn6yGRZORqA2v+LfMrNLh4GITI0Rw=";
  };

  doCheck = true;

  # this force to skip "collapse_home" tests, because $HOME != getpwuid in the
  # sandbox
  preCheck = ''
    unset HOME
  '';

  meta = {
    description = "Unit tests, property-based tests, snapshot tests, and expect tests in a single package with one API.";
    homepage = "https://ocaml.org/p/windtrap";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.joblade ];
  };
})
