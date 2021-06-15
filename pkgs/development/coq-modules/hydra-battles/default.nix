{ lib, mkCoqDerivation, coq, mathcomp, equations, paramcoq, version ? null }:
with lib;

mkCoqDerivation {
  pname = "hydra-battles";
  owner = "coq-community";

  release."0.3".rev    = "v0.3";
  release."0.3".sha256 = "sha256-rXP/vJqVEg2tN/I9LWV13YQ1+C7M6lzGu3oI+7pSZzg=";

  inherit version;
  defaultVersion = with versions; switch coq.coq-version [
    { case = isGe "8.11"; out = "0.3"; }
  ] null;

  propagatedBuildInputs = [ mathcomp equations paramcoq ];

  meta = {
    description = "Variations on Kirby & Paris' hydra battles and other entertaining math in Coq";
    longDescription = ''
       Variations on Kirby & Paris' hydra battles and other
       entertaining math in Coq (collaborative, documented, includes
       exercises)
    '';
    maintainers = with maintainers; [ siraben ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
