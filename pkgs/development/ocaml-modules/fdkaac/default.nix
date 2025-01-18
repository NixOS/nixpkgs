{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  dune-configurator,
  fdk_aac,
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

  meta = with lib; {
    description = "OCaml binding for the fdk-aac library";
    inherit (src.meta) homepage;
    license = licenses.gpl2Only;
    maintainers = [
      maintainers.vbgl
      maintainers.dandellion
    ];
  };

}
