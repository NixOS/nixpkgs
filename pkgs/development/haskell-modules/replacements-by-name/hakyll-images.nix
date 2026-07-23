{
  mkDerivation,
  base,
  binary,
  bytestring,
  containers,
  directory,
  filepath,
  hakyll,
  HUnit-approx,
  JuicyPixels,
  JuicyPixels-extra,
  lib,
  tasty,
  tasty-hunit,
  vector,
}:
mkDerivation {
  pname = "hakyll-images";
  version = "1.3.1";
  sha256 = "a4f55f08b10671795beab1e3d8496651e3c0a08799d26f36b6357480753e85a8";
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    base
    binary
    bytestring
    hakyll
    JuicyPixels
    JuicyPixels-extra
    vector
  ];
  testHaskellDepends = [
    base
    binary
    bytestring
    containers
    directory
    filepath
    hakyll
    HUnit-approx
    JuicyPixels
    JuicyPixels-extra
    tasty
    tasty-hunit
    vector
  ];
  homepage = "https://github.com/LaurentRDC/hakyll-images#readme";
  description = "Hakyll utilities to work with images";
  license = lib.licensesSpdx."BSD-3-Clause";
}
