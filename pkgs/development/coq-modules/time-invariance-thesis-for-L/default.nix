{ lib, mkCoqDerivation, smpl, equations, metacoq, coq, version ? null }:
with lib;

mkCoqDerivation {
  pname = "time-invariance-thesis-for-L";
  owner = "uds-psl";

  release."8.12".rev = "41f4eb1f788cc4f096d9c7c286c9ca907588859f";
  release."8.12".sha256 = "sha256-fkBZKpOEZ+aqcF7bZRJN4CMcTVgy6rf+fYnLvbhxUsA=";

  inherit version;
  defaultVersion = with versions; switch coq.version [
    { case = isGe "8.12"; out = "8.12"; }
  ] null;

  propagatedBuildInputs = [ smpl equations metacoq ];

  meta = {
    description = "A Mechanised Proof of the Time Invariance Thesis for the Weak Call-by-value λ-Calculus";
    maintainers = with maintainers; [ siraben ];
    license = licenses.cecill21;
    platforms = platforms.unix;
  };
}
