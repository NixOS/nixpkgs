{
  mkDerivation,
  extra-cmake-modules,
  bzip2, xz, qtbase, zlib, zstd
}:

mkDerivation {
  pname = "karchive";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ bzip2 xz zlib zstd ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
