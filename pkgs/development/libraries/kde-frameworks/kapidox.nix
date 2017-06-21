{ mkDerivation, lib, extra-cmake-modules, python }:

mkDerivation {
  name = "kapidox";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules python ];
  postFixup = ''
    moveToOutput bin $bin
  '';
}
