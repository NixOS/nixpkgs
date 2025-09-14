{
  lib,
  stdenv,
  fetchurl,
  boost,
  openssl,
  version,
  sha256,
  ...
}:

stdenv.mkDerivation {
  pname = "asio";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/asio/asio-${version}.tar.bz2";
    inherit sha256;
  };

  propagatedBuildInputs = [ boost ];

  buildInputs = [ openssl ];

  meta = {
    homepage = "http://asio.sourceforge.net/";
    description = "Cross-platform C++ library for network and low-level I/O programming";
    license = lib.licenses.boost;
    broken = stdenv.hostPlatform.isDarwin && lib.versionOlder version "1.16.1";
    platforms = lib.platforms.unix;
  };
}
