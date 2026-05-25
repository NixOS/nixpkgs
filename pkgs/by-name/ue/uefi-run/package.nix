{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uefi-run";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "Richard-W";
    repo = "uefi-run";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tR547osqw18dCMHJLqJ8AQBelbv8yCl7rAqslu+vnDQ=";
  };

  cargoHash = "sha256-c9aooU60zN58/m8q4G/f8VOjq7oXUTqxqSUMp47YOcA=";

  meta = {
    description = "Directly run UEFI applications in qemu";
    homepage = "https://github.com/Richard-W/uefi-run";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "uefi-run";
  };
})
