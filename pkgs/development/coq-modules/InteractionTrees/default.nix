{ stdenv, fetchFromGitHub, coq, mk-coq-ext-lib, mk-paco, version ? null }:

let
  InteractionTrees-versions = {
    "1_0_0" = {
      version = "1.0.0";
      rev = "1.0.0";
      sha256 = "1g59844fcypk7fq7l8zvh6vk1gziaq79byvihahamhcy7yq60dr5";
      coq-ext-lib-version = "0_10_0";
      paco-version = "2_1_0";
    };
    "20191104" = {
      version = "20191104";
      rev = "d408b9151f7f77d1ab0b8a0f2d57f210e16206ae";
      sha256 = "1pjad3y6y7nmmjd9hyw6zn1314igkxd3vcj1rmnariff69slcpdk";
      coq-ext-lib-version = "0_10_2";
      paco-version = "4_0_0";
    };
  };
  default-versions = {
    "8.8" = InteractionTrees-versions."1_0_0";
    "8.9" = InteractionTrees-versions."1_0_0";
  };
  param =
    if version == null
    then default-versions.${coq.coq-version}
    else InteractionTrees-versions.${version};

  coq-ext-lib = mk-coq-ext-lib { version = param.coq-ext-lib-version; };
  paco = mk-paco { version = param.paco-version; };

in

stdenv.mkDerivation rec {
  inherit (param) version;
  name = "coq${coq.coq-version}-InteractionTrees-${version}";

  src = fetchFromGitHub {
    inherit (param) rev sha256;
    owner = "DeepSpec";
    repo = "InteractionTrees";
  };

  buildInputs = [ coq ];
  propagatedBuildInputs = [ coq-ext-lib paco ];

  enableParallelBuilding = true;

  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  meta = with stdenv.lib; {
    homepage = https://github.com/DeepSpec/InteractionTrees;
    description = "A library for representing recursive and impure programs in Coq";
    license = licenses.mit;
    maintainers = with maintainers; [ ptival ];
    platforms = coq.meta.platforms;
  };

  passthru = {
    compatibleCoqVersions = v: builtins.hasAttr v default-versions;
  };
}
