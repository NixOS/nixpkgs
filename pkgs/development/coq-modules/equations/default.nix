{ stdenv, fetchFromGitHub, coq }:

let
  params = {
    "8.6" = {
      version = "1.0";
      rev = "v1.0";
      sha256 = "19ylw9v9g35607w4hm86j7mmkghh07hmkc1ls5bqlz3dizh5q4pj";
    };

    "8.7" = {
      version = "1.0";
      rev = "v1.0-8.7";
      sha256 = "1bavg4zl1xn0jqrdq8iw7xqzdvdf39ligj9saz5m9c507zri952h";
    };

    "8.8" = {
      version = "1.2beta2";
      rev = "v1.2-beta2-8.8";
      sha256 = "1v9asdlhhks25ngnjn4dafx7nrcc5p0lhriqckh3y79nxbgpq4lx";
    };

    "8.9" = {
      version = "1.2beta2";
      rev = "v1.2-beta2-8.9";
      sha256 = "0y2zwv7jxs1crprj5qvg46h0v9wyfn99ln40yskq91y9h1lj5h3j";
    };
  };
  param = params."${coq.coq-version}";
in

stdenv.mkDerivation rec {

  name = "coq${coq.coq-version}-equations-${version}";
  version = "${param.version}";

  src = fetchFromGitHub {
    owner = "mattam82";
    repo = "Coq-Equations";
    rev = "${param.rev}";
    sha256 = "${param.sha256}";
  };

  buildInputs = with coq.ocamlPackages; [ ocaml camlp5 findlib coq ];

  preBuild = "coq_makefile -f _CoqProject -o Makefile";

  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  meta = with stdenv.lib; {
    homepage = https://mattam82.github.io/Coq-Equations/;
    description = "A plugin for Coq to add dependent pattern-matching";
    maintainers = with maintainers; [ jwiegley ];
    platforms = coq.meta.platforms;
  };

  passthru = {
    compatibleCoqVersions = v: builtins.hasAttr v params;
  };

}
