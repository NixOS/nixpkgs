{ stdenv, fetchFromGitHub, coq }:

let param =
  {
    "8.4" = { version = "0.9.0"; sha256 = "1n3bk003vvbghbrxkhal6drnc0l65jv9y77wd56is3jw9xgiif0w"; };
    "8.5" = { version = "0.9.3"; sha256 = "05zff5mrkxpvcsw4gi8whjj5w0mdbqzjmb247lq5b7mry0bypwc5"; };
  }."${coq.coq-version}";
in

stdenv.mkDerivation rec {

  name = "coq${coq.coq-version}-coq-ext-lib-${version}";
  inherit (param) version;

  src = fetchFromGitHub {
    owner = "coq-ext-lib";
    repo = "coq-ext-lib";
    rev = "v${param.version}";
    inherit (param) sha256;
  };

  buildInputs = [ coq.ocaml coq.camlp5 ];
  propagatedBuildInputs = [ coq ];

  enableParallelBuilding = true;

  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  meta = with stdenv.lib; {
    homepage = https://github.com/coq-ext-lib/coq-ext-lib;
    description = "A collection of theories and plugins that may be useful in other Coq developments";
    maintainers = with maintainers; [ jwiegley ];
    platforms = coq.meta.platforms;
  };

}
