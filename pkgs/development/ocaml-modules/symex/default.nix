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
  version = "0.1";

  src = fetchFromGitHub {
    owner = "ocamlpro";
    repo = "symex";
    tag = finalAttrs.version;
    hash = "sha256-jKwFtxVcBD8Y1bfKRB8Z/MSeQLQWKvk00i8HqodkBbM=";
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
