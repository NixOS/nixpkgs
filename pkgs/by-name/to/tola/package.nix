{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tola";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "KawaYww";
    repo = "tola";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SItwtT5zQaK17m1Vp9xkxAFKYT22glIUbBv8CB92Rps=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-bDQHdBxj4rarNnZDmPsClDaOqrdMCzM5usWX+9raYOU=";

  # There are not any tests in source project.
  doCheck = false;

  meta = {
    description = "A static site generator for typst-based blog, written in Rust";
    homepage = "https://github.com/KawaYww/tola";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kawayww
    ];
  };
})
