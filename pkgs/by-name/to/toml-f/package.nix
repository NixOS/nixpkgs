{
  stdenv,
  lib,
  fetchFromGitHub,
  gfortran,
  buildType ? "meson",
  meson,
  ninja,
  cmake,
  pkg-config,
  test-drive,
}:

assert (
  builtins.elem buildType [
    "meson"
    "cmake"
  ]
);

stdenv.mkDerivation (finalAttrs: {
  pname = "toml-f";
  version = "0.5.1";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "toml-f";
    repo = "toml-f";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lReez2rSAJVnLFngjUYgGkm+HUDH8VsCC2m9zYOOr4A=";
  };

  patches = [
    # Fix wrong generation of package config include paths
    ./cmake.patch
  ];

  nativeBuildInputs = [
    gfortran
    pkg-config
  ]
  ++ lib.optionals (buildType == "meson") [
    meson
    ninja
  ]
  ++ lib.optionals (buildType == "cmake") [
    cmake
  ];

  buildInputs = [ test-drive ];

  outputs = [
    "out"
    "dev"
  ];

  cmakeFlags = [
    "-Dtest-drive_DIR=${test-drive}"
  ];

  # tftest-build fails on aarch64-linux
  doCheck = !stdenv.hostPlatform.isAarch64;

  meta = {
    description = "TOML parser implementation for data serialization and deserialization in Fortran";
    license = with lib.licenses; [
      asl20
      mit
    ];
    homepage = "https://github.com/toml-f/toml-f";
    changelog = "https://github.com/toml-f/toml-f/releases/tag/${finalAttrs.src.tag}";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.sheepforce ];
  };
})
