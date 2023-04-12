{ lib, stdenv, fetchurl, expat, curl, fftw }:

stdenv.mkDerivation rec {
  pname = "libofa";
  version = "0.9.3";
  deb_patch = "5";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/musicip-libofa/${pname}-${version}.tar.gz";
    sha256 = "184ham039l7lwhfgg0xr2vch2xnw1lwh7sid432mh879adhlc5h2";
  };

  patches = fetchurl {
    url = "mirror://debian/pool/main/libo/libofa/libofa_${version}-${deb_patch}.debian.tar.gz";
    sha256 = "1rfkyz13cm8izm90c1xflp4rvsa24aqs6qpbbbqqcbmvzsj6j9yn";
  };

  outputs = [ "out" "dev" ];

  setOutputFlags = false;

  preConfigure = ''
    configureFlagsArray=(--includedir=$dev/include --libdir=$out/lib)
  '';

  propagatedBuildInputs = [ expat curl fftw ];

  meta = with lib; {
    homepage = "https://code.google.com/archive/p/musicip-libofa/";
    description = "Library Open Fingerprint Architecture";
    longDescription = ''
      LibOFA (Library Open Fingerprint Architecture) is an open-source audio
      fingerprint created and provided by MusicIP'';
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
