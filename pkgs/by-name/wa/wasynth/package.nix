{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wasynth";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "Rerumu";
    repo = "Wasynth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0Gtqet6KKLtooh9cU2R/top142AeT+uIxFwe1dPTvAU=";
  };

  # A lock file isn't provided, so it must be added manually.
  cargoLock.lockFile = ./Cargo.lock;
  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  # Not all of the tests pass.
  doCheck = false;

  # These binaries are tests and should be removed.
  postInstall = ''
    rm $out/bin/{luajit,luau}_translate
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--generate-lockfile" ];
  };

  meta = {
    description = "WebAssembly translation tools for various languages";
    longDescription = ''
      Wasynth provides the following WebAssembly translation tools:
       * wasm2luajit: translate WebAssembly to LuaJIT source code
       * wasm2luau: translate WebAssembly Luau source code
    '';
    homepage = "https://github.com/Rerumu/Wasynth";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = [ ];
  };
})
