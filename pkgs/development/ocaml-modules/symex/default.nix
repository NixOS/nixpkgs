{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  fmt,
  prelude,
  smtml,
}:

buildDunePackage (finalAttrs: {
  pname = "symex";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "ocamlpro";
    repo = "symex";
    tag = finalAttrs.version;
    hash = "sha256-KX+OHiCsAHEw0kBWLUDVakIcshUNXLYjm2f2le75Mj8=";
  };

  propagatedBuildInputs = [
    fmt
    prelude
    smtml
  ];

  meta = {
    description = "Primitives to write symbolic execution engines";
    homepage = "https://github.com/ocamlpro/symex";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ redianthus ];
  };
})
