{
  lib,
  mkCoqDerivation,
  coq,
  version ? null,
}:

mkCoqDerivation {
  pname = "semantics";
  owner = "coq-community";
  releaseRev = v: "v${v}";

  release."8.14.0".sha256 = "sha256-TB12C3hX9XucbsXr+UL+8jM19NOFXASW/lcytwy6uVE=";
  release."8.13.0".sha256 = "sha256-8bDr/Ovl6s8BFaRcHeS5H33/K/pYdeKfSN+krVuKulQ=";
  release."8.11.1".sha256 = "sha256-jTPgcXSNn1G2mMDC7ocFcmqs8svB7Yo1emXP15iuxiU=";
  release."8.9.0".sha256 = "sha256-UBsvzlDEZsZsVkbUI0GbFEhpxnnLCiaqlqDyWVC5I6s=";
  release."8.8.0".sha256 = "sha256-k2nQyNw9KT3wY7bGy8KGILF44sLxkBYqdFpzFE9fgyw=";
  release."8.7.0".sha256 = "sha256-k2nQyNw9KT3wY7bGy8KGILF44sLxkBYqdFpzFE9fgyw=";
  release."8.6.0".sha256 = "sha256-GltkGQ3tJqUPAbdDkqqvKLLhMOap50XvGaCkjshiNdY=";

  inherit version;
  defaultVersion =
    with lib.versions;
    lib.switch coq.coq-version [
      {
        case = range "8.10" "8.18";
        out = "8.14.0";
      }
      {
        case = "8.9";
        out = "8.9.0";
      }
      {
        case = "8.8";
        out = "8.8.0";
      }
      {
        case = "8.7";
        out = "8.7.0";
      }
      {
        case = "8.6";
        out = "8.6.0";
      }
    ] null;

  mlPlugin = true;
  nativeBuildInputs = (with coq.ocamlPackages; [ ocamlbuild ]);
  propagatedBuildInputs = (with coq.ocamlPackages; [ num ]);

  postPatch = ''
    for p in Make Makefile.coq.local
    do
      substituteInPlace $p --replace "-libs nums" "-use-ocamlfind -package num" || true
    done
  '';

  meta = with lib; {
    description = "Survey of programming language semantics styles in Coq";
    longDescription = ''
      A survey of semantics styles in Coq, from natural semantics through
      structural operational, axiomatic, and denotational semantics, to
      abstract interpretation
    '';
    maintainers = with maintainers; [ siraben ];
    license = licenses.mit;
  };
}
