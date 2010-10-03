{ stdenv, fetchurl, ruby, qt4, pkgconfig, libsamplerate, fftwSinglePrec }:

stdenv.mkDerivation rec {
  name = "liblastfm-0.3.0";

  src = fetchurl {
    url = "http://cdn.last.fm/src/${name}.tar.bz2";
    sha256 = "0vgpkbqmynm975nlcw3caxpz30wvvz35c7a9kfr2wjqizvxrfwnx";
  };

  prefixKey = "--prefix ";
  propagatedBuildInputs = [ qt4 libsamplerate fftwSinglePrec ];
  buildInputs = [ ruby pkgconfig ];

  patchPhase = "patchShebangs .";

  meta = {
    homepage = http://github.com/mxcl/liblastfm;
    description = "Official LastFM library";
    inherit (qt4.meta) platforms;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
