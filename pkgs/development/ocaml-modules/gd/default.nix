{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-configurator,
  gd,
}:

buildDunePackage (finalAttrs: {
  pname = "gd";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-gd";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-78cqxVEappTybRLk7Y6vW1POvZKFIxtGNVcmkKq9GEE=";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ gd ];

  meta = {
    homepage = "https://github.com/savonet/ocaml-gd";
    description = "OCaml bindings for gd";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ dandellion ];
  };
})
