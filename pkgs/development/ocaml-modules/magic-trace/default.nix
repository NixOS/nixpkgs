{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  ocaml-crunch,
  angstrom,
  async,
  camlzip,
  cohttp,
  cohttp_static_handler ? null,
  core,
  core_unix ? null,
  fzf,
  owee,
  ppx_jane,
  re,
  shell ? null,
  zstandard ? null,
}:

buildDunePackage (finalAttrs: {
  pname = "magic-trace";
  version = "1.2.4";

  minimalOCamlVersion = "4.12";

  src = fetchFromGitHub {
    owner = "janestreet";
    repo = "magic-trace";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LkhnlOd5rI8cbOYbVqrkRJ2qTcRn3Zzl6GjQEdjBjVA=";
  };

  nativeBuildInputs = [
    ocaml-crunch
  ];

  buildInputs = [
    angstrom
    async
    camlzip
    cohttp
    cohttp_static_handler
    core
    core_unix
    fzf
    owee
    ppx_jane
    re
    shell
    zstandard
  ];

  meta = {
    description = "Collects and displays high-resolution traces of what a process is doing";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.alizter ];
    homepage = "https://github.com/janestreet/magic-trace";
    platforms = lib.platforms.linux;
    mainProgram = "magic-trace";
  };
})
