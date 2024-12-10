{
  lib,
  stdenv,
  fetchFromGitHub,
  zig_0_11,
  testers,
  tigerbeetle,
  nix-update-script,
}:
let
  # Read [these comments](pkgs/development/compilers/zig/hook.nix#L12-L30) on the default Zig flags, and the associated links. tigerbeetle stopped exposing the `-Doptimize` build flag, so we can't use the default Nixpkgs zig hook as-is. tigerbeetle only exposes a boolean `-Drelease` flag which we'll add in the tigerbeetle derivation in this file.
  custom_zig_hook = zig_0_11.hook.overrideAttrs (previousAttrs: {
    zig_default_flags = builtins.filter (
      flag: builtins.match "-Doptimize.*" flag == null
    ) previousAttrs.zig_default_flags;
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "tigerbeetle";
  version = "0.15.3";

  src = fetchFromGitHub {
    owner = "tigerbeetle";
    repo = "tigerbeetle";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-3+uCMoOnyvI//ltEaqTIXytUxxgJrfMnFly11WCh66Q=";
  };

  env.TIGERBEETLE_RELEASE = finalAttrs.version;

  nativeBuildInputs = [ custom_zig_hook ];

  zigBuildFlags = [
    "-Drelease"
    "-Dgit-commit=0000000000000000000000000000000000000000"
  ];

  passthru = {
    tests.version = testers.testVersion {
      package = tigerbeetle;
      command = "tigerbeetle version";
    };
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://tigerbeetle.com/";
    description = "A financial accounting database designed to be distributed and fast";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ danielsidhion ];
    platforms = lib.platforms.linux;
    mainProgram = "tigerbeetle";
  };
})
