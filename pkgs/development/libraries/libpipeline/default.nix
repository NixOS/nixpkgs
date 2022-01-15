{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libpipeline";
  version = "1.5.4";

  src = fetchurl {
    url = "mirror://savannah/libpipeline/libpipeline-${version}.tar.gz";
    sha256 = "sha256-23hb3boKN+8UtO+Cri0YuIJOaYPfuZEDGTheKN8/Gpw=";
  };

  patches = lib.optionals stdenv.isDarwin [ ./fix-on-osx.patch ];

  meta = with lib; {
    homepage = "http://libpipeline.nongnu.org";
    description = "C library for manipulating pipelines of subprocesses in a flexible and convenient way";
    platforms = platforms.unix;
    license = licenses.gpl3;
  };
}
