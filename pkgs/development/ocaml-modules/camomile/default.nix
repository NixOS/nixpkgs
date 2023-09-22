{ lib
, stdenv
, buildDunePackage
, fetchFromGitHub
, writeScriptBin
, darwin
, dune-site
, camlp-streams
, nix-update-script
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

  nativeBuildInputs = lib.optionals stdenv.isDarwin [
    # libc++abi: terminating with uncaught exception of type SigTool::NotAMachOFileException: std::exception
    (writeScriptBin "codesign" ''
      #!${stdenv.shell}
    '')
  ];

  propagatedNativeBuildInputs = [
    # Error: Program codesign not found in the tree or in PATH
    darwin.sigtool
  ];

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
