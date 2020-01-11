{ stdenv
, lib
, fetchpatch
, buildPythonPackage
, fetchPypi
, pythonOlder
, swig2
, openssl
, typing
}:


buildPythonPackage rec {
  version = "0.35.2";
  pname = "M2Crypto";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09yirf3w77w6f49q6nxhrjm9c3a4y9s30s1k09chqrw8zdgx8sjc";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/void-linux/void-packages/raw/7946d12eb3d815e5ecd4578f1a6133d948694370/srcpkgs/python-M2Crypto/patches/libressl.patch";
      sha256 = "0z5qnkndg6ma5f5qqrid5m95i9kybsr000v3fdy1ab562kf65a27";
    })
  ];
  patchFlags = [ "-p0" ];

  nativeBuildInputs = [ swig2 ];
  buildInputs = [ swig2 openssl ];

  propagatedBuildInputs = lib.optional (pythonOlder "3.5") typing;

  preConfigure = ''
    substituteInPlace setup.py --replace "self.openssl = '/usr'" "self.openssl = '${openssl.dev}'"
  '';

  doCheck = false; # another test that depends on the network.

  meta = with stdenv.lib; {
    description = "A Python crypto and SSL toolkit";
    homepage = https://gitlab.com/m2crypto/m2crypto;
    license = licenses.mit;
    maintainers = with maintainers; [ andrew-d ];
  };

}
