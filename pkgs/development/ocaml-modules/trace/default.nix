{
  lib,
  fetchFromGitHub,
  buildDunePackage,
}:

buildDunePackage (finalAttrs: {
  pname = "trace";
  version = "0.12";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ocaml-tracing";
    repo = "ocaml-trace";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9XWimCLsBpLZ0TtPzWYs4t8cEx/okRzKw4xNwCS0tfc=";
  };

  meta = {
    description = "Common interface for tracing/instrumentation libraries in OCaml";
    license = lib.licenses.mit;
    homepage = "https://ocaml-tracing.github.io/ocaml-trace/";
    maintainers = [ lib.maintainers.vbgl ];
  };
})
