{
  mkDerivation, lib, copyPathsToStore,
  extra-cmake-modules,
  plymouth
}:

mkDerivation {
  name = "breeze-plymouth";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ plymouth ];
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
  postPatch = ''
      substituteInPlace cmake/FindPlymouth.cmake --subst-var out
  '';
}
