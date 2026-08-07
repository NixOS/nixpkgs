{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (oldAttrs: {
  pname = "yggdrasil-ng";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "Revertron";
    repo = "Yggdrasil-ng";
    tag = "v${oldAttrs.version}";
    hash = "sha256-idhtzN1qJQ50u+1KjFVAxttR2pHKPp6iFvL6XTp3XFQ=";
  };

  cargoHash = "sha256-qJrRz2JIkQD185XY3tSbJFKZWCY0+1heT6MhIeH/52A=";

  __structuredAttrs = true;

  meta = {
    mainProgram = "telemt";
    description = "Yggdrasil Network rewritten in Rust";
    homepage = "https://github.com/Revertron/Yggdrasil-ng";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      r4v3n6101
      malik
    ];
  };
})
