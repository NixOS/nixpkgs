{
  mkDerivation,
  extra-cmake-modules,
  libdmtx, qrencode, qtbase,
}:

mkDerivation {
  pname = "prison";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ libdmtx qrencode ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
