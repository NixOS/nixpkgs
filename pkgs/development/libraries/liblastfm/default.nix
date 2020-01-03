{ stdenv, fetchurl, qt4, pkgconfig, libsamplerate, fftwSinglePrec, which, cmake
, darwin }:

let version = "1.1.0"; in

stdenv.mkDerivation rec {
  pname = "liblastfm";
  inherit version;

  # Upstream does not package git tags as tarballs. Get tarball from github.
  src = fetchurl {
    url = "https://github.com/lastfm/liblastfm/tarball/${version}";
    name = "${pname}-${version}.tar.gz";
    sha256 = "1j34xc30vg7sfszm2jx9mlz9hy7p1l929fka9wnfcpbib8gfi43x";
  };

  prefixKey = "--prefix ";
  propagatedBuildInputs = [ qt4 libsamplerate fftwSinglePrec ];
  nativeBuildInputs = [ pkgconfig which cmake ];
  buildInputs = stdenv.lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.SystemConfiguration;

  meta = with stdenv.lib; {
    homepage = https://github.com/lastfm/liblastfm;
    repositories.git = git://github.com/lastfm/liblastfm.git;
    description = "Official LastFM library";
    inherit (qt4.meta) platforms;
    maintainers =  [ maintainers.phreedom ];
    license = licenses.gpl3;
  };
}
