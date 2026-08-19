{ mkDerivation, base, bytestring, deepseq, fetchzip, filepath, lib
, tasty, tasty-hunit, temporary, unix
}:
mkDerivation {
  pname = "file-io";
  version = "0.1.5";
  src = fetchzip {
    url = "https://hackage.haskell.org/package/file-io-0.1.5/file-io-0.1.5.tar.gz";
    sha256 = "09974wdxd006cg27h5q3ary8hq5ihjmkw5kcl78qxm52qq206fv1";
  };
  libraryHaskellDepends = [ base bytestring deepseq filepath unix ];
  testHaskellDepends = [
    base bytestring filepath tasty tasty-hunit temporary
  ];
  homepage = "https://github.com/hasufell/file-io";
  description = "Basic file IO operations via 'OsPath'";
  license = lib.meta.getLicenseFromSpdxId "BSD-3-Clause";
}
