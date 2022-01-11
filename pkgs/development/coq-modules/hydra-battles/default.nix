{ lib, mkCoqDerivation, coq, equations, version ? null }:
with lib;

mkCoqDerivation {
  pname = "hydra-battles";
  owner = "coq-community";

  release."0.4".sha256 = "1f7pc4w3kir4c9p0fjx5l77401bx12y72nmqxrqs3qqd3iynvqlp";
  release."0.5".sha256 = "121pcbn6v59l0c165ha9n00whbddpy11npx2y9cn7g879sfk2nqk";
  releaseRev = (v: "v${v}");

  inherit version;
  defaultVersion = with versions; switch coq.coq-version [
    { case = range "8.13" "8.14"; out = "0.5"; }
    { case = range "8.11" "8.12"; out = "0.4"; }
  ] null;

  propagatedBuildInputs = [ equations ];

  useDune2 = true;

  meta = {
    description = "Exploration of some properties of Kirby and Paris' hydra battles, with the help of Coq";
    longDescription = ''
      An exploration of some properties of Kirby and Paris' hydra
      battles, with the help of the Coq Proof assistant. This
      development includes the study of several representations of
      ordinal numbers, and a part of the so-called Ketonen and Solovay
      machinery (combinatorial properties of epsilon0).
    '';
    maintainers = with maintainers; [ siraben Zimmi48 ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
