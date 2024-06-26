{
  stdenv,
  lib,
  fetchFromGitHub,
  gfortran,
  meson,
  ninja,
  pkg-config,
  test-drive,
}:

stdenv.mkDerivation rec {
  pname = "toml-f";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+cac4rUNpd2w3yBdH1XoCKdJ9IgOHZioZg8AhzGY0FE=";
  };

  nativeBuildInputs = [
    gfortran
    meson
    ninja
    pkg-config
  ];

  buildInputs = [ test-drive ];

  outputs = [
    "out"
    "dev"
  ];

  # tftest-build fails on aarch64-linux
  doCheck = !stdenv.isAarch64;

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
