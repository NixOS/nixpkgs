{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (oldAttrs: {
  pname = "yggdrasil-ng";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "Revertron";
    repo = "Yggdrasil-ng";
    tag = "v${oldAttrs.version}";
    hash = "sha256-UAux898QNT+2EyU4oLJZjmPZmHvv81SyHhx24uV+UeA=";
  };

  cargoHash = "sha256-wcfMhqQXkHxqPXoZC6jWdtjpEcF/LHG9eOvckJFB6Ok=";

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
