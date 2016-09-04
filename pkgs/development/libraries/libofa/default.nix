{ stdenv, fetchurl, expat, curl, fftw }:

let
  version = "0.9.3";
  deb_patch = "5";
in
stdenv.mkDerivation rec {
  name = "libofa-${version}";

  src = fetchurl {
    url = "http://musicip-libofa.googlecode.com/files/${name}.tar.gz";
    sha256 = "184ham039l7lwhfgg0xr2vch2xnw1lwh7sid432mh879adhlc5h2";
  };

  patches = fetchurl {
    url = "mirror://debian/pool/main/libo/libofa/libofa_${version}-${deb_patch}.debian.tar.gz";
    sha256 = "1rfkyz13cm8izm90c1xflp4rvsa24aqs6qpbbbqqcbmvzsj6j9yn";
  };

  propagatedBuildInputs = [ expat curl fftw ];

  meta = {
    homepage = http://code.google.com/musicip-libofa/;
    description = "Library Open Fingerprint Architecture";
    longDescription = ''
      LibOFA (Library Open Fingerprint Architecture) is an open-source audio
      fingerprint created and provided by MusicIP'';
    platforms = stdenv.lib.platforms.linux;
  };
}
