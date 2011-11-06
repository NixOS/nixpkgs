{ stdenv, fetchurl, expat, curl, fftw }:

stdenv.mkDerivation rec {
  name = "libofa-0.9.3";

  propagatedBuildInputs = [ expat curl fftw ];

  patches = [ ./libofa-0.9.3-gcc-4.patch ./libofa-0.9.3-gcc-4.3.patch ./gcc-4.x.patch ./curl-types.patch ];

  src = fetchurl {
    url = "http://musicip-libofa.googlecode.com/files/${name}.tar.gz";
    sha256 = "184ham039l7lwhfgg0xr2vch2xnw1lwh7sid432mh879adhlc5h2";
  };

  meta = {
    homepage = http://code.google.com/musicip-libofa/;
    description = "LibOFA - Library Open Fingerprint Architecture";
    longDescription = ''
      LibOFA (Library Open Fingerprint Architecture) is an open-source audio
      fingerprint created and provided by MusicIP'';
  };
}
