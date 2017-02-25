{
  plasmaPackage, lib, copyPathsToStore,
  ecm,
  plymouth
}:

plasmaPackage {
  name = "breeze-plymouth";
  nativeBuildInputs = [ ecm ];
  buildInputs = [ plymouth ];
  outputs = [ "out" ];
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
  postPatch = ''
      substituteInPlace cmake/FindPlymouth.cmake --subst-var out
  '';
}
