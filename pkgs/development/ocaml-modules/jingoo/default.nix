{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  menhir,
  ppx_deriving,
  re,
  uutf,
  uucp,
  ounit2,
}:

buildDunePackage (finalAttrs: {
  pname = "jingoo";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "tategakibunko";
    repo = "jingoo";
    tag = finalAttrs.version;
    hash = "sha256-FltjCOGGztYm3tFqRkdWmNmopmC8DDhhmY0LqfYgh40=";
  };

  nativeBuildInputs = [ menhir ];
  propagatedBuildInputs = [
    ppx_deriving
    re
    uutf
    uucp
  ];
  checkInputs = [ ounit2 ];
  doCheck = true;

  meta = {
    homepage = "https://github.com/tategakibunko/jingoo";
    description = "OCaml template engine almost compatible with jinja2";
    mainProgram = "jingoo";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ericbmerritt ];
  };
})
