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

stdenv.mkDerivation rec {
  pname = "toml-f";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "toml-f";
    repo = "toml-f";
    rev = "v${version}";
    hash = "sha256-+cac4rUNpd2w3yBdH1XoCKdJ9IgOHZioZg8AhzGY0FE=";
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
  ++ lib.optional (buildType == "cmake") cmake;

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

  meta = with lib; {
    description = "TOML parser implementation for data serialization and deserialization in Fortran";
    license = with licenses; [
      asl20
      mit
    ];
    homepage = "https://github.com/toml-f/toml-f";
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
