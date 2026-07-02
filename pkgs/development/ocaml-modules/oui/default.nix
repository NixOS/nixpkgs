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
  version = "0-unstable-2025-12-02";

  minimalOCamlVersion = "4.13";

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "ocaml-universal-installer";
    rev = "202dae889c4850674f7b40ca8d541f98afa2ba0f";
    hash = "sha256-pwvp6bJF18NzKh/JSet05VHoJNZ7FKr0Hsi/RJ/TK4U=";
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
