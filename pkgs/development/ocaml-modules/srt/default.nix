{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-configurator,
  posix-socket,
  srt,
  ctypes-foreign,
}:

buildDunePackage (finalAttrs: {
  pname = "srt";
  version = "0.3.4";

  minimalOCamlVersion = "4.12";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-srt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+1/TffqssRA9YR3KLfbAr/ZpDF5XUKw24gj4HWrhObU=";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [
    ctypes-foreign
    posix-socket
    srt
  ];

  meta = {
    description = "OCaml bindings for the libsrt library";
    license = lib.licenses.gpl2Plus;
    homepage = "https://github.com/savonet/ocaml-srt";
    maintainers = with lib.maintainers; [
      vbgl
      dandellion
    ];
  };
})
