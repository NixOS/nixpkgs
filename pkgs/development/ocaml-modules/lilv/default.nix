{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-configurator,
  ctypes,
  ctypes-foreign,
  lilv,
}:

buildDunePackage (finalAttrs: {
  pname = "lilv";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-lilv";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DIEWQ+0FcrvIGt7uAUyqpzwVc//uNmpxmfl2TRhSEiA=";
  };

  minimalOCamlVersion = "4.03.0";

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [
    ctypes
    ctypes-foreign
    lilv
  ];

  meta = {
    homepage = "https://github.com/savonet/ocaml-lilv";
    description = "OCaml bindings for lilv";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ dandellion ];
  };
})
