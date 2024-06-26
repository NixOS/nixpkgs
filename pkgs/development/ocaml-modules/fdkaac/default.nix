{ lib, fetchFromGitHub, buildDunePackage, dune-configurator
, fdk_aac
}:

buildDunePackage rec {
  pname = "fdkaac";
  version = "0.3.3";
  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-fdkaac";
    rev = "v${version}";
    hash = "sha256-cTPPQKBq0EFo35eK7TXlszbodHYIg1g7v+yQ/rG7Y9I=";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ fdk_aac ];

  meta = {
    description = "OCaml binding for the fdk-aac library";
    inherit (src.meta) homepage;
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.vbgl lib.maintainers.dandellion ];
  };

}
