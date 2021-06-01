{ lib, mkCoqDerivation, coq, version ? null }:
with lib;

mkCoqDerivation {
  pname = "zorns-lemma";

  releaseRev = v: "v${v}";

  release."8.11.0".sha256 = "sha256-2Hf7YwRcFmP/DqwFtF1p78MCNV50qUWfMVQtZbwKd0k=";
  release."8.10.0".sha256 = "sha256-qLPLK2ZLJQ4SmJX2ADqFiP4kgHuQFJTeNXkBbjiFS+4=";
  release."8.9.0".sha256 = "sha256-lEh978cXehglFX9D92RVltEuvN8umfPo/hvmFZm2NGo=";
  release."8.8.0".sha256 = "sha256-ikXGzABu8VW7O0xNtCNvIq29c+mlDUm4k/ygVcsgDOI=";
  release."8.7.0".sha256 = "sha256-jozvkkKLFBllN6K4oeYD0lNG+MdnOuKrDUPDocHUG6c=";
  release."8.6.0".sha256 = "sha256-jozvkkKLFBllN6K4oeYD0lNG+MdnOuKrDUPDocHUG6c=";
  release."8.5.0".sha256 = "sha256-mH/v02ObMjbVPYx2H+Jhz+Xp0XRKN67iMAdA1VNFzso=";

  inherit version;
  defaultVersion = with versions; switch coq.coq-version [
    { case = isGe "8.11"; out = "8.11.0"; }
    { case = "8.10"; out = "8.10.0"; }
    { case = "8.9"; out = "8.9.0"; }
    { case = "8.8"; out = "8.8.0"; }
    { case = "8.7"; out = "8.7.0"; }
    { case = "8.6"; out = "8.6.0"; }
    { case = "8.5"; out = "8.5.0"; }
  ] null;

  meta = {
    description = "Development of basic set theory";
    longDescription = ''
      This Coq library develops some basic set theory.  The main
      purpose the author had in writing it was as support for the
      Topology library.
    '';
    maintainers = with maintainers; [ siraben ];
    license = licenses.lgpl21Plus;
  };
}
