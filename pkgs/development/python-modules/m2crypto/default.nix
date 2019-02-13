{ stdenv
, fetchpatch
, buildPythonPackage
, fetchPypi
, swig2
, openssl
, typing
}:


buildPythonPackage rec {
  version = "0.30.1";
  pname = "M2Crypto";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a1b2751cdadc6afac3df8a5799676b7b7c67a6ad144bb62d38563062e7cd3fc6";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/void-linux/void-packages/raw/7946d12eb3d815e5ecd4578f1a6133d948694370/srcpkgs/python-M2Crypto/patches/libressl.patch";
      sha256 = "0z5qnkndg6ma5f5qqrid5m95i9kybsr000v3fdy1ab562kf65a27";
    })
  ];
  patchFlags = "-p0";

  buildInputs = [ swig2 openssl ];

  propagatedBuildInputs = [ typing ];

  preConfigure = ''
    substituteInPlace setup.py --replace "self.openssl = '/usr'" "self.openssl = '${openssl.dev}'"
  '';

  doCheck = false; # another test that depends on the network.

  meta = with stdenv.lib; {
    description = "A Python crypto and SSL toolkit";
    homepage = http://chandlerproject.org/Projects/MeTooCrypto;
    license = licenses.mit;
    maintainers = with maintainers; [ andrew-d ];
  };

}
