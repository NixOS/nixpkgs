{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  ppxlib,
  version ? if lib.versionAtLeast ppxlib.version "0.36.0" then "2.0" else "1.0",
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
        "2.0" = "sha256-W5CBBderCFV6tSSryJgL9Y6Quw8FH3VkPhZVsD05GRU=";
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
