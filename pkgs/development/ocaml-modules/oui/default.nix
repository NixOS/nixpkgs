{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  cmdliner,
  fmt,
  markup,
  ocaml-crunch,
  opam-client,
  opam-format,
  ppx_deriving_yojson,
  ppx_expect,
  yojson,
}:

buildDunePackage (finalAttrs: {
  pname = "oui";
  version = "0-unstable-2025-10-08";

  minimalOCamlVersion = "4.10";

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "ocaml-universal-installer";
    rev = "2fe2e33c3f8e1744fdd4dab04458043451bf9f62";
    hash = "sha256-ALQIQ3Ab1Gs2xST9OwsO5IxixzgKlUg7uHZvfHMbv7Q=";
  };

  nativeBuildInputs = [
    ocaml-crunch
  ];

  propagatedBuildInputs = [
    cmdliner
    fmt
    markup
    opam-client
    opam-format
    ppx_deriving_yojson
    yojson
  ];

  # upstream tests are matching full library paths
  doCheck = false;
  checkInputs = [
    ppx_expect
  ];

  meta = {
    homepage = "https://github.com/OCamlPro/ocaml-universal-installer";
    description = "A tool that builds standalone installers for your OCaml applications";
    longDescription = ''
      oui is a command-line tool that generates standalone installers for
      Linux, Windows and macOS from your OCaml and non OCaml binaries.
    '';
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.stepbrobd ];
    mainProgram = "opam-oui";
  };
})
