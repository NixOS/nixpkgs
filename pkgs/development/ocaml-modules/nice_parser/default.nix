{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  stdio,
}:

buildDunePackage rec {
  pname = "nice_parser";
  version = "1.0.0";
  minimalOCamlVersion = "4.07";

  src = fetchFromGitHub {
    owner = "smolkaj";
    repo = "nice-parser";
    tag = version;
    hash = "sha256-h1rqdv19tUH3CsL3OLsTmKir7YCYt4PaW19ymotEvIY=";
  };

  propagatedBuildInputs = [
    stdio
  ];

  meta = {
    inherit (src.meta) homepage;
    description = "Nice parsers without the boilerplate";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.tiferrei ];
  };
}
