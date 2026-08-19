{
  mkDerivation,
  base,
  bytestring,
  fetchzip,
  filepath,
  lib,
  tasty,
  tasty-hunit,
  tasty-quickcheck,
  time,
}:
mkDerivation {
  pname = "unix";
  version = "2.8.8.0";
  src = fetchzip {
    url = "https://hackage.haskell.org/package/unix-2.8.8.0/unix-2.8.8.0.tar.gz";
    sha256 = "1mcrgidq8in50mrjm37ialc134ckrwm6iw0xf0iq6pdyhpqg8y10";
  };
  libraryHaskellDepends = [
    base
    bytestring
    filepath
    time
  ];
  testHaskellDepends = [
    base
    bytestring
    filepath
    tasty
    tasty-hunit
    tasty-quickcheck
  ];
  homepage = "https://github.com/haskell/unix";
  description = "POSIX functionality";
  license = lib.licenses.bsd3;
}
