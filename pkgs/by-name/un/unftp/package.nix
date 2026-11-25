{
  aws-lc,
  fetchFromGitHub,
  lib,
  libgit2,
  nix-update-script,
  pkg-config,
  versionCheckHook,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "unftp";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "Cloudinvoke";
    repo = "unftp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rlgpHPhBrHQW4fo+QLxG/0Z50KSHQmYAEGpCcqJ1mGk=";
  };

  cargoHash = "sha256-54vz348nuyufocDIh+HlkYTub1Wq0ICF+iE1+YnULCI=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    aws-lc
    libgit2
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "FTP(S) server with a couple of twists written in Rust";
    homepage = "https://unftp.rs/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aiyion ];
    mainProgram = "unftp";
  };
})
