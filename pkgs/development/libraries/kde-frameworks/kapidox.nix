{ mkDerivation, lib, extra-cmake-modules, python2 }:

mkDerivation {
  name = "kapidox";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules python2 ];
  postFixup = ''
    moveToOutput bin $bin
  '';
}
