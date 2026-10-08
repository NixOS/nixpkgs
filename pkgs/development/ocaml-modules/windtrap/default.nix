{
  lib,
  fetchurl,
  buildDunePackage,
}:

buildDunePackage {
  pname = "windtrap";
  version = "0.1.0";
  minimalOCamlVersion = "5.0";

  src = fetchurl {
    url = "https://github.com/invariant-hq/windtrap/releases/download/0.1.0/windtrap-0.1.0.tbz";
    hash = "sha256-IkGylLJO1dVuqLg00pbm+rxdvdkkqJ9RwUsA2mbFCiU=";
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
}
