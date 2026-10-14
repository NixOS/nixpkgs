{
  lib,
  buildPythonPackage,
  pydantic-monty,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "pydantic-monty-runtime";
  inherit (pydantic-monty) version src;
  pyproject = true;
  __structuredAttrs = true;

  # `&mut Box<[T; N]>` is not `IntoIterator` with the packaged Rust,
  # although upstream declares `rust-version = "1.96"`
  postPatch = ''
    substituteInPlace ../monty/src/modules/json/string_cache.rs \
      --replace-fail \
        "for entry in &mut inner.entries {" \
        "for entry in inner.entries.iter_mut() {"
  '';

  cargoRoot = "../..";
  sourceRoot = "${finalAttrs.src.name}/crates/monty-runtime";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      src
      version
      cargoRoot
      sourceRoot
      ;
    hash = "sha256-kcL0aZ3U8ENQULVP3QBsQhBm+wSodLk0r3hw7HutubU=";
  };

  # The workspace root is outside of `sourceRoot`, hence not writable
  env.CARGO_TARGET_DIR = "./target";

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  nativeCheckInputs = [
    rustPlatform.cargoCheckHook
  ];

  meta = {
    description = "Monty CLI binary — spawned as worker subprocesses by pydantic-monty";
    homepage = "https://github.com/pydantic/monty/blob/main/crates/monty-runtime";
    changelog = "https://github.com/pydantic/monty/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    inherit (pydantic-monty.meta) maintainers;
  };
})
