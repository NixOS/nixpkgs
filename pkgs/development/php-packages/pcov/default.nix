{ buildPecl, lib, pcre' }:

buildPecl {
  pname = "pcov";

  version = "1.0.6";
  sha256 = "1psfwscrc025z8mziq69pcx60k4fbkqa5g2ia8lplb94mmarj0v1";

  buildInputs = [ pcre' ];

  meta.maintainers = lib.teams.php.members;
}
