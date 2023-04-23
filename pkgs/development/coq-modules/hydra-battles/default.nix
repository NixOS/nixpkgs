{ lib, mkCoqDerivation, coq, equations, LibHyps, version ? null }:

(mkCoqDerivation {
  pname = "hydra-battles";
  owner = "coq-community";

  release."0.4".sha256 = "1f7pc4w3kir4c9p0fjx5l77401bx12y72nmqxrqs3qqd3iynvqlp";
  release."0.5".sha256 = "121pcbn6v59l0c165ha9n00whbddpy11npx2y9cn7g879sfk2nqk";
  release."0.6".sha256 = "1dri4sisa7mhclf8w4kw7ixs5zxm8xyjr034r1377p96rdk3jj0j";
  releaseRev = (v: "v${v}");

  inherit version;
  defaultVersion = with lib.versions; lib.switch coq.coq-version [
    { case = range "8.13" "8.16"; out = "0.6"; }
    { case = range "8.11" "8.12"; out = "0.4"; }
  ] null;

  useDune = true;

  meta = with lib; {
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
}).overrideAttrs(o:
  let inherit (o) version; in {
    propagatedBuildInputs = [ equations ] ++ lib.optional (lib.versions.isGe "0.6" version || version == "dev") LibHyps;
  })
