{
  callPackage,
  gz-cmake_3,
}:

(callPackage ./generic.nix {
  gz-cmake = gz-cmake_3;
})
  {
    version = "2.2.0";
    hash = "sha256-dNoDOZtk/zseHuOM5mOPHkXKU7wqxxKrFnh7e09bjRA=";
  }
