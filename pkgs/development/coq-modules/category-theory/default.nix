{ stdenv, fetchgit, coq, ssreflect, equations }:

let
  params =
    let
    v20180709 = {
      version = "20180709";
      rev = "3b9ba7b26a64d49a55e8b6ccea570a7f32c11ead";
      sha256 = "0f2nr8dgn1ab7hr7jrdmr1zla9g9h8216q4yf4wnff9qkln8sbbs";
    };
    v20181016 = {
      version = "20181016";
      rev = "8049479c5aee00ed0b92e5edc7c8996aebf48208";
      sha256 = "14f9rlwh8vgmcl6njykvsiwxx0jn623375afixk26mzpy12zdcph";
    };
  in {
    "8.6" = v20180709;
    "8.7" = v20180709;
    "8.8" = v20181016;
  };
  param = params."${coq.coq-version}";
in

stdenv.mkDerivation rec {

  name = "coq${coq.coq-version}-category-theory-${param.version}";

  src = fetchgit {
    url = git://github.com/jwiegley/category-theory.git;
    inherit (param) rev sha256;
  };

  buildInputs = [ coq ] ++ (with coq.ocamlPackages; [ ocaml camlp5 findlib ]);
  propagatedBuildInputs = [ ssreflect equations ];

  buildFlags = [ "JOBS=$(NIX_BUILD_CORES)" ];

  installPhase = ''
    make -f Makefile.coq COQLIB=$out/lib/coq/${coq.coq-version}/ install
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/jwiegley/category-theory;
    description = "A formalization of category theory in Coq for personal study and practical work";
    maintainers = with maintainers; [ jwiegley ];
    platforms = coq.meta.platforms;
  };

  passthru = {
    compatibleCoqVersions = v: builtins.hasAttr v params;
  };

}
