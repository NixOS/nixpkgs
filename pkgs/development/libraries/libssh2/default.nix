{ lib
, stdenv
, fetchurl
, openssl
, zlib
, windows

# for passthru.tests
, aria2
, curl
, libgit2
, mc
, vlc
}:

stdenv.mkDerivation rec {
  pname = "libssh2";
  version = "1.11.0";

  src = fetchurl {
    url = "https://www.libssh2.org/download/libssh2-${version}.tar.gz";
    sha256 = "sha256-NzYWHkHiaTMk3rOMJs/cPv5iCdY0ukJY2xzs/2pa1GE=";
  };

  outputs = [ "out" "dev" "devdoc" ];

  propagatedBuildInputs = [ openssl ]; # see Libs: in libssh2.pc
  buildInputs = [ zlib ]
    ++ lib.optional stdenv.hostPlatform.isMinGW windows.mingw_w64;

  passthru.tests = {
    inherit aria2 libgit2 mc vlc;
    curl = (curl.override { scpSupport = true; }).tests.withCheck;
  };

  meta = with lib; {
    description = "A client-side C library implementing the SSH2 protocol";
    homepage = "https://www.libssh2.org";
    platforms = platforms.all;
    license = with licenses; [ bsd3 libssh2 ];
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
