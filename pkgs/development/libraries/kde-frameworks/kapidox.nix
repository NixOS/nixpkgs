{ mkDerivation, lib, extra-cmake-modules, python3 }:

mkDerivation {
  pname = "kapidox";
  nativeBuildInputs = [ extra-cmake-modules python3 python3.pkgs.setuptools ];
  postFixup = ''
    moveToOutput bin $bin
  '';
}
