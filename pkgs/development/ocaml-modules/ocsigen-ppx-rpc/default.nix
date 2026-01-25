{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  ppxlib,
}:

buildDunePackage (finalAttrs: {
  pname = "ocsigen-ppx-rpc";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = "ocsigen-ppx-rpc";
    rev = finalAttrs.version;
    sha256 = "sha256:0qgasd89ayamgl2rfyxsipznmwa3pjllkyq9qg0g1f41h8ixpsfh";
  };

  propagatedBuildInputs = [ ppxlib ];

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "Syntax for RPCs for Eliom and Ocsigen Start";
    license = lib.licenses.lgpl21Only;
    maintainers = [ lib.maintainers.vbgl ];
    broken = lib.versionAtLeast ppxlib.version "0.36";
  };

})
