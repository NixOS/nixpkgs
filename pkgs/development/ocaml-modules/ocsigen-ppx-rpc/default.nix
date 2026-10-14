{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  ppxlib,
  version ? if lib.versionAtLeast ppxlib.version "0.36.0" then "1.1" else "1.0",
}:

buildDunePackage {
  pname = "ocsigen-ppx-rpc";
  inherit version;

  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = "ocsigen-ppx-rpc";
    tag = version;
    hash =
      {
        "1.0" = "sha256:0qgasd89ayamgl2rfyxsipznmwa3pjllkyq9qg0g1f41h8ixpsfh";
        "1.1" = "sha256-YjRB0cem+iDnQIIQcHI6vo5crSxAGNGM65qyG3lTtkE=";
      }
      ."${version}";
  };

  propagatedBuildInputs = [ ppxlib ];

  meta = {
    homepage = "https://github.com/ocsigen/ocsigen-ppx-rpc/";
    description = "Syntax for RPCs for Eliom and Ocsigen Start";
    license = lib.licenses.lgpl21Only;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
