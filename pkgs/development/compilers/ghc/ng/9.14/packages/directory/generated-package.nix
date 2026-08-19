{ mkDerivation, base, fetchzip, file-io, filepath, lib, time, unix
}:
mkDerivation {
  pname = "directory";
  version = "1.3.10.0";
  src = fetchzip {
    url = "https://hackage.haskell.org/package/directory-1.3.10.0/directory-1.3.10.0.tar.gz";
    sha256 = "17w2nlmkd3r414jp77rimp0nfpdjq0pqvq981kaix52bln63nn54";
  };
  libraryHaskellDepends = [ base file-io filepath time unix ];
  testHaskellDepends = [ base filepath time unix ];
  description = "Platform-agnostic library for filesystem operations";
  license = lib.meta.getLicenseFromSpdxId "BSD-3-Clause";
}
