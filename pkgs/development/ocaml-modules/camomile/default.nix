{ lib, fetchFromGitHub, nix-update-script
, buildDunePackage
, dune-site, camlp-streams
}:

buildDunePackage rec {
  pname = "camomile";
  version = "2.0.0";

  minimalOCamlVersion = "4.13";

  src = fetchFromGitHub {
    owner = "ocaml-community";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-HklX+VPD0Ta3Knv++dBT2rhsDSlDRH90k4Cj1YtWIa8=";
  };

  propagatedBuildInputs = [
    dune-site
    camlp-streams
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    inherit (src.meta) homepage;
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.lgpl21;
    description = "A Unicode library for OCaml";
  };
}
