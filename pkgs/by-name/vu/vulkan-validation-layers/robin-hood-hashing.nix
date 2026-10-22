{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "robin-hood-hashing";
  version = "3.11.5"; # pin

  src = fetchFromGitHub {
    owner = "martinus";
    repo = "robin-hood-hashing";
    rev = finalAttrs.version; # pin
    sha256 = "sha256-J4u9Q6cXF0SLHbomP42AAn5LSKBYeVgTooOhqxOIpuM=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DRH_STANDALONE_PROJECT=OFF"
  ];

  meta = {
    description = "Faster, more efficient replacement for std::unordered_map / std::unordered_set";
    homepage = "https://github.com/martinus/robin-hood-hashing";
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
