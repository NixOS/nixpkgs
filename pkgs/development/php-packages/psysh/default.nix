{ fetchFromGitHub, lib, php }:

php.buildComposerProject (finalAttrs: {
  pname = "psysh";
  version = "0.11.20";

  src = fetchFromGitHub {
    owner = "bobthecow";
    repo = "psysh";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Bcpmn0rCjNMeGvF1CGg4uatakUtMY1H1o759CK15b0o=";
  };

  vendorHash = "sha256-1XPDgaiWVenGSGluDciQAm9qQTL9vGJk9AqkTviRa+c=";

  meta = {
    changelog = "https://github.com/bobthecow/psysh/releases/tag/v${finalAttrs.version}";
    description = "PsySH is a runtime developer console, interactive debugger and REPL for PHP.";
    license = lib.licenses.mit;
    homepage = "https://psysh.org/";
    maintainers = lib.teams.php.members;
  };
})
