{ lib, fetchFromGitHub, php }:

php.buildComposerProject (finalAttrs: {
  pname = "pdepend";
  version = "2.13.0";

  src = fetchFromGitHub {
    owner = "pdepend";
    repo = "pdepend";
    rev = finalAttrs.version;
    hash = "sha256-OmqbZwXzWbSM9+ViytfCRjLpw36M4MErmn4FnCAyPBg=";
  };

  # TODO: Open a PR against https://github.com/pdepend/pdepend
  # Missing `composer.lock` from the repository.
  composerLock = ./composer.lock;
  vendorHash = "sha256-cEPJN6bsmsg8iMjzFjV3QoTtzpPFPVItbE/UGL6vhRQ=";

  meta = with lib; {
    description = "An adaptation of JDepend for PHP";
    homepage = "https://github.com/pdepend/pdepend";
    license = licenses.bsd3;
    longDescription = "
      PHP Depend is an adaptation of the established Java
      development tool JDepend. This tool shows you the quality
      of your design in terms of extensibility, reusability and
      maintainability.
    ";
    maintainers = teams.php.members;
  };
})
