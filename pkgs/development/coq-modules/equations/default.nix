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
      version = "1.2.1";
      rev = "v1.2.1-8.9";
      sha256 = "0d8ddj6nc6p0k25cd8fs17cq427zhzbc3v9pk2wd2fnvk70nlfij";
    };

    "8.10" = {
      version = "1.2.1";
      rev = "v1.2.1-8.10-2";
      sha256 = "0j3z4l5nrbyi9zbbyqkc6kassjanwld2188mwmrbqspaypm2ys68";
    };

    "8.11" = {
      version = "1.2.3";
      rev = "v1.2.3-8.11";
      sha256 = "1srxz1rws8jsh7402g2x2vcqgjbbsr64dxxj5d2zs48pmhb20csf";
    };

    "8.12" = {
      version = "1.2.3";
      rev = "v1.2.3-8.12";
      sha256 = "1y0jkvzyz5ssv5vby41p1i8zs7nsdc8g3pzyq73ih9jz8h252643";
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
    homepage = "https://mattam82.github.io/Coq-Equations/";
    description = "A plugin for Coq to add dependent pattern-matching";
    maintainers = with maintainers; [ jwiegley ];
    platforms = coq.meta.platforms;
  };

  passthru = {
    compatibleCoqVersions = v: builtins.hasAttr v params;
  };

}
