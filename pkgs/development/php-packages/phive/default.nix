{
  lib,
  fetchFromGitHub,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "phive";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "phar-io";
    repo = "phive";
    tag = finalAttrs.version;
    hash = "sha256-dv9v1KCLNheFmrRQ7cID5WFvoiH0OWVPWSrN023dEqA=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-9X8z+A4uHsO1w8CdQkKZ/sZ+5BHooRD2q7ij6epr/Yc=";
=======
  vendorHash = "sha256-U6BHAd4tWQKm6uCJ5sM51PltXhF3J4ieTnbC060+8Jg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    changelog = "https://github.com/phar-io/phive/releases/tag/${finalAttrs.version}";
    description = "Phar Installation and Verification Environment (PHIVE)";
    homepage = "https://github.com/phar-io/phive";
    license = lib.licenses.bsd3;
    mainProgram = "phive";
    teams = [ lib.teams.php ];
  };
})
