{
  lib,
  fetchFromGitHub,
  buildDunePackage,
}:

buildDunePackage rec {
  pname = "afl-persistent";
  version = "1.4";

  minimalOCamlVersion = "4.05";

  src = fetchFromGitHub {
    owner = "stedolan";
    repo = "ocaml-${pname}";
    tag = "v${version}";
    hash = "sha256-kksGXaoO7lhaPI+rDOOQ39BUJjk6MGPBYQLumuW9gTg=";
  };

  doCheck = true;

  meta = {
    homepage = "https://github.com/stedolan/ocaml-afl-persistent";
    description = "persistent-mode afl-fuzz for ocaml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sternenseemann ];
  };
}
