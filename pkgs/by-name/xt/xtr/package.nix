{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xtr";
  version = "0.1.11";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-ouuctuXZp97OWfM8IfJUMG9WdVji6WCGD2L5mXWHs/I=";
  };

  cargoHash = "sha256-1nqFGYbW8d4I+H2yyD/cyUE0UmYpYgy5pQ/0aDKpP5w=";

  meta = {
    description = "Extract strings from a rust crate to be translated with gettext";
    homepage = "https://crates.io/crates/xtr";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ pineapplehunter ];
    mainProgram = "xtr";
  };
})
