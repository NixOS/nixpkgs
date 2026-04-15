{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  ocaml,
  cmdliner,
  dap,
  fmt,
  iter,
  logs,
  lru,
  lwt_ppx,
  lwt_react,
  menhir,
  menhirLib,
  path_glob,
  ppx_deriving_yojson,
  ppx_optcomp,
  gitUpdater,
}:

buildDunePackage (finalAttrs: {
  pname = "earlybird";
  version = "1.3.5";

  minimalOCamlVersion = "4.12";

  src = fetchFromGitHub {
    owner = "hackwaly";
    repo = "ocamlearlybird";
    tag = finalAttrs.version;
    hash = "sha256-QDRtuphOb02L75JyCF9K1NqvIdtWlfefeLG3HmJVHW4=";
  };

  nativeBuildInputs = [ menhir ];

  buildInputs = [
    cmdliner
    dap
    fmt
    iter
    logs
    lru
    lwt_ppx
    lwt_react
    menhirLib
    path_glob
    ppx_deriving_yojson
    ppx_optcomp
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://github.com/hackwaly/ocamlearlybird";
    description = "OCaml debug adapter";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.romildo ];
  };
})
