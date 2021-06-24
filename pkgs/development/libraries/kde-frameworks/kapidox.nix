{ mkDerivation, lib, extra-cmake-modules, python3 }:

mkDerivation {
  name = "kapidox";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules python3 python3.pkgs.setuptools ];
  postFixup = ''
    moveToOutput bin $bin
  '';
}
