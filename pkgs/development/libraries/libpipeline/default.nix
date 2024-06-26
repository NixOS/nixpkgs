{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "libpipeline";
  version = "1.5.7";

  src = fetchurl {
    url = "mirror://savannah/libpipeline/libpipeline-${version}.tar.gz";
    sha256 = "sha256-uLRRlJiQIqeewTF/ZKKnWxVRsqVb6gb2dwTLKi5GkLA=";
  };

  patches = lib.optionals stdenv.isDarwin [ ./fix-on-osx.patch ];

  meta = with lib; {
    homepage = "http://libpipeline.nongnu.org";
    description = "C library for manipulating pipelines of subprocesses in a flexible and convenient way";
    platforms = platforms.unix;
    license = licenses.gpl3;
  };
}
