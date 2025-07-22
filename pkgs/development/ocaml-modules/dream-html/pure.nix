{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  uri,
}:

buildDunePackage rec {
  pname = "pure-html";
  version = "3.11.0";

  src = fetchFromGitHub {
    owner = "yawaramin";
    repo = "dream-html";
    tag = "v${version}";
    hash = "sha256-YBzL9B1mDbomGr1kT6RW+wg4y0JH6IiIlJYVMRptFFg=";
  };

  propagatedBuildInputs = [ uri ];

  meta = {
    description = "Write HTML directly in your OCaml source files with editor support";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.naora ];
  };
}
