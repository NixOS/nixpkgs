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
      version = "1.2";
      rev = "v1.2-8.8";
      sha256 = "06452fyzalz7zcjjp73qb7d6xvmqb6skljkivf8pfm55fsc8s7kx";
    };

    "8.9" = {
      version = "1.2";
      rev = "v1.2-8.9";
      sha256 = "1q3wvicr43bgy7xn1diwh4j43mnrhprrc2xd22qlbz9cl6bhf8bj";
    };

    "8.10" = {
      version = "1.2";
      rev = "v1.2-8.10";
      sha256 = "1v5kx0xzxzsbs5r4w08rm1lrmjjggnd3ap0sd1my88ds17jzyasd";
    };
  };
  param = params.${coq.coq-version};
in

stdenv.mkDerivation rec {

  name = "coq${coq.coq-version}-equations-${version}";
  version = param.version;

  src = fetchFromGitHub {
    owner = "mattam82";
    repo = "Coq-Equations";
    rev = param.rev;
    sha256 = param.sha256;
  };

  buildInputs = with coq.ocamlPackages; [ ocaml camlp5 findlib coq ];

  preBuild = "coq_makefile -f _CoqProject -o Makefile";

  installFlags = [ "COQLIB=$(out)/lib/coq/${coq.coq-version}/" ];

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
