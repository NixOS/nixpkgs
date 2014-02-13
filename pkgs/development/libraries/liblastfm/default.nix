{ stdenv, fetchurl, qt4, pkgconfig, libsamplerate, fftwSinglePrec, which, cmake }:

let version = "1.0.7"; in

stdenv.mkDerivation rec {
  name = "liblastfm-${version}";

  # Upstream does not package git tags as tarballs. Get tarball from github.
  src = fetchurl {
    url = "https://github.com/lastfm/liblastfm/tarball/${version}";
    name = "${name}.tar.gz";
    sha256 = "1837gd2azy8r34rcmsn2m1zngk4v2hpk7q0ii60dhjjvjaaswkwq";
  };

  prefixKey = "--prefix ";
  propagatedBuildInputs = [ qt4 libsamplerate fftwSinglePrec ];
  nativeBuildInputs = [ pkgconfig which cmake ];

  meta = {
    homepage = http://github.com/lastfm/liblastfm;
    repositories.git = git://github.com/lastfm/liblastfm.git;
    description = "Official LastFM library";
    inherit (qt4.meta) platforms;
    maintainers = with stdenv.lib.maintainers; [ urkud phreedom ];
  };
}
