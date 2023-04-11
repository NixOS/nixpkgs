{ lib, fetchFromGitHub, php }:

php.buildComposerProject (finalAttrs: {
  pname = "pdepend";
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "pdepend";
    repo = "pdepend";
    rev = finalAttrs.version;
    hash = "sha256-ZmgMuOpUsx5JWTcPRS6qKbTWZvuOrBVOVdPMcvvTV20=";
  };

  # TODO: Open a PR against https://github.com/pdepend/pdepend
  # Missing `composer.lock` from the repository.
  composerLock = ./composer.lock;
  vendorHash = "sha256-DqMj3LrkpmKCxyQbr3/YKqwWOuJew7wHVwuxDf2pOfY=";

  meta = {
    description = "An adaptation of JDepend for PHP";
    homepage = "https://github.com/pdepend/pdepend";
    license = lib.licenses.bsd3;
    longDescription = "
      PHP Depend is an adaptation of the established Java
      development tool JDepend. This tool shows you the quality
      of your design in terms of extensibility, reusability and
      maintainability.
    ";
    maintainers = lib.teams.php.members;
  };
})
