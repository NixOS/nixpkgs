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
    description = "A static site generator for typst-based blog, written in Rust";
    homepage = "https://github.com/tola-rs/tola-ssg";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
  };
})
