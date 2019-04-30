{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libpipeline-1.5.1";

  src = fetchurl {
    url = "mirror://savannah/libpipeline/${name}.tar.gz";
    sha256 = "0bwh5xz5f2czwb7f564jz1mp4znm8pldnvf65fs0hpw4gmmp0cyn";
  };

  patches = stdenv.lib.optionals stdenv.isDarwin [ ./fix-on-osx.patch ];

  meta = with stdenv.lib; {
    homepage = http://libpipeline.nongnu.org;
    description = "C library for manipulating pipelines of subprocesses in a flexible and convenient way";
    platforms = platforms.unix;
    license = licenses.gpl3;
  };
}
