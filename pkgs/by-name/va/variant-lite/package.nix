{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "variant-lite";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "martinmoene";
    repo = "variant-lite";
    rev = "v${version}";
    hash = "sha256-zLyzNzeD0C4e7CYqCCsPzkqa2cH5pSbL9vNVIxdkEfc=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  doCheck = true;

  meta = with lib; {
    description = ''A C++17-like variant, a type-safe union for C++98, C++11 and later in a single-file header-only library'';
    homepage = "https://github.com/martinmoene/variant-lite";
    changelog = "https://github.com/martinmoene/variant-lite/blob/${src.rev}/CHANGES.txt";
    license = licenses.boost;
    maintainers = with maintainers; [ titaniumtown ];
  };
}
