{
  mkDerivation,
  extra-cmake-modules,
  bzip2, xz, qtbase, zlib,
}:

mkDerivation {
  name = "karchive";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ bzip2 xz zlib ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
