{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-configurator,
  posix-socket,
  srt,
  ctypes-foreign,
}:

buildDunePackage rec {
  pname = "srt";
  version = "0.3.1";

  minimalOCamlVersion = "4.12";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-srt";
    rev = "v${version}";
    hash = "sha256-5KBiHNnZ+ukaXLC90ku9PqGUUK6csDY9VqVKeeX6BQ8=";
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
    inherit (src.meta) homepage;
    maintainers = with lib.maintainers; [
      vbgl
      dandellion
    ];
  };
}
