{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;
  pname = "tola";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "tola-rs";
    repo = "tola-ssg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nFM+EXi3njnyfUxEGYPvk4izmmVs4ZW2ebOEGCwey+I=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    openssl
  ];

  cargoHash = "sha256-0cpAm4QHvgH0VlZm65/5pmD82nTBl23kHkNouiyXFyE=";

  # There are not any tests in source project.
  doCheck = false;

  meta = {
    description = "Typst-based static site generator";
    homepage = "https://tola.build";
    license = lib.licenses.mit;
    mainProgram = "tola";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      kawayww
      matthiasbeyer
    ];
  };
})
