{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  uri,
}:

buildDunePackage (finalAttrs: {
  pname = "pure-html";
  version = "3.11.2";

  src = fetchFromGitHub {
    owner = "yawaramin";
    repo = "dream-html";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/I233A86T+QEb2qbSHucgzRzYEjS08eKezSXOwz2ml0=";
  };

  doCheck = true;

  propagatedBuildInputs = [ uri ];

  meta = {
    description = "Write HTML directly in your OCaml source files with editor support";
    homepage = "https://github.com/yawaramin/dream-html";
    changelog = "https://raw.githubusercontent.com/yawaramin/dream-html/refs/tags/v${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.naora ];
  };
})
