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
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "KawaYww";
    repo = "tola";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zgPKsIRXp5na2d0X7j5+9xJBGFSlvIKIRmzVVo/dcLk=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    openssl
  ];

  cargoHash = "sha256-3Y7+UJD2QyNs+GjijvOAyTQ9ZP7lRf/MpaWThN2/e5s=";

  # There are not any tests in source project.
  doCheck = false;

  meta = {
    description = "A static site generator for typst-based blog, written in Rust";
    homepage = "https://github.com/KawaYww/tola";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
  };
})
