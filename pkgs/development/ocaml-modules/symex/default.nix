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
  version = "0.3";

  src = fetchFromGitHub {
    owner = "ocamlpro";
    repo = "symex";
    tag = finalAttrs.version;
    hash = "sha256-4p7FnaNP4GPatkpWBwD3OZYFlkKzyNoQFf4Kdc/39wo=";
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
