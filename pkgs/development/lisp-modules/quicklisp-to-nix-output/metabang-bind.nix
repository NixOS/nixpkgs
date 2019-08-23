args @ { fetchurl, ... }:
rec {
  baseName = ''metabang-bind'';
  version = ''20171130-git'';

  description = ''Bind is a macro that generalizes multiple-value-bind, let, let*, destructuring-bind, structure and slot accessors, and a whole lot more.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/metabang-bind/2017-11-30/metabang-bind-20171130-git.tgz'';
    sha256 = ''0mjcg4281qljjwzq80r9j7nhvccf5k1069kzk2vljvvm2ai21j1a'';
  };

  packageName = "metabang-bind";

  asdFilesToKeep = ["metabang-bind.asd"];
  overrides = x: x;
}
/* (SYSTEM metabang-bind DESCRIPTION
    Bind is a macro that generalizes multiple-value-bind, let, let*, destructuring-bind, structure and slot accessors, and a whole lot more.
    SHA256 0mjcg4281qljjwzq80r9j7nhvccf5k1069kzk2vljvvm2ai21j1a URL
    http://beta.quicklisp.org/archive/metabang-bind/2017-11-30/metabang-bind-20171130-git.tgz
    MD5 dfd06d3929c2f48ccbe1d00cdf9995a7 NAME metabang-bind FILENAME
    metabang-bind DEPS NIL DEPENDENCIES NIL VERSION 20171130-git SIBLINGS
    (metabang-bind-test) PARASITES NIL) */
