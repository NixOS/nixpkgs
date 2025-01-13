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
    rev = "v${version}";
    sha256 = "sha256-kksGXaoO7lhaPI+rDOOQ39BUJjk6MGPBYQLumuW9gTg=";
  };

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/stedolan/ocaml-afl-persistent";
    description = "persistent-mode afl-fuzz for ocaml";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
  };
}
