{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  useWildLinker,
  nix-update-script,
}:
let
  # wild is only used on Linux tier-1 arches.
  hasWild =
    stdenv.hostPlatform.isLinux && (stdenv.hostPlatform.isx86_64 || stdenv.hostPlatform.isAarch64);
  stdenv' = if hasWild then useWildLinker stdenv else stdenv;
  buildRustPackage = rustPlatform.buildRustPackage.override { stdenv = stdenv'; };
in
buildRustPackage (finalAttrs: {
  pname = "tack";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "manic-systems";
    repo = "tack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KhJb0NWLhj8AkD8uWEbXt179YlFLemk0OgOltw4jEk8=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  cargoHash = "sha256-3vDMM5uTsmRso6McH/b3+RpjeKjhgQm9V1piBrnSRjk=";

  # replace lines which override our stdenv changes
  postPatch = ''
    substituteInPlace .cargo/config.toml \
      --replace-fail 'linker    = "clang"' "" \
      --replace-fail 'rustflags = [ "-Clink-arg=--ld-path=wild" ]' ""
  '';

  env = lib.optionalAttrs hasWild {
    "CARGO_TARGET_${stdenv.hostPlatform.rust.cargoEnvVarTarget}_LINKER" =
      "${stdenv'.cc}/bin/${stdenv'.cc.targetPrefix}cc";
  };

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/manic-systems/tack";
    description = "flake-like toml nix pins, lazily fetched and transformed";
    mainProgram = "tack";
    license = [ lib.licenses.eupl12 ];
    maintainers = with lib.maintainers; [
      amaanq
      atagen
      faukah
      max
      NotAShelf
    ];
  };
})
