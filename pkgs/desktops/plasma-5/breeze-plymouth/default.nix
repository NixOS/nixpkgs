{
  plasmaPackage, lib, copyPathsToStore,
  extra-cmake-modules,
  plymouth
}:

plasmaPackage {
  name = "breeze-plymouth";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ plymouth ];
  outputs = [ "out" ];
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
  postPatch = ''
      substituteInPlace cmake/FindPlymouth.cmake --subst-var out
  '';
}
