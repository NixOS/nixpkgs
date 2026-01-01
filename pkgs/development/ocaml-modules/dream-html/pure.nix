{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  uri,
}:

<<<<<<< HEAD
buildDunePackage (finalAttrs: {
  pname = "pure-html";
  version = "3.11.2";
=======
buildDunePackage rec {
  pname = "pure-html";
  version = "3.11.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "yawaramin";
    repo = "dream-html";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
    hash = "sha256-/I233A86T+QEb2qbSHucgzRzYEjS08eKezSXOwz2ml0=";
  };

  doCheck = true;

=======
    tag = "v${version}";
    hash = "sha256-L/q3nxUONPdZtzmfCfP8nnNCwQNSpeYI0hqowioGYNg=";
  };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  propagatedBuildInputs = [ uri ];

  meta = {
    description = "Write HTML directly in your OCaml source files with editor support";
<<<<<<< HEAD
    homepage = "https://github.com/yawaramin/dream-html";
    changelog = "https://raw.githubusercontent.com/yawaramin/dream-html/refs/tags/v${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.naora ];
  };
})
=======
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.naora ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
