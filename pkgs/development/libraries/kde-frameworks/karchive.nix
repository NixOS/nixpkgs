{
  mkDerivation,
  extra-cmake-modules,
  bzip2,
  xz,
  qtbase,
  qttools,
  zlib,
  zstd,
}:

mkDerivation {
  pname = "karchive";
  nativeBuildInputs = [
    extra-cmake-modules
    qttools
  ];
  buildInputs = [
    bzip2
    xz
    zlib
    zstd
  ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [
    "out"
    "dev"
  ];
}
