{ stdenv, fetchurl, qt4, pkgconfig, libsamplerate, fftwSinglePrec, which, cmake
, darwin }:

let version = "1.0.9"; in

stdenv.mkDerivation rec {
  name = "liblastfm-${version}";

  # Upstream does not package git tags as tarballs. Get tarball from github.
  src = fetchurl {
    url = "https://github.com/lastfm/liblastfm/tarball/${version}";
    name = "${name}.tar.gz";
    sha256 = "09qiaxsxw6g2m7mvkffpfsi5wis8nl1x4lgnk0sa30859z54iw53";
  };

  prefixKey = "--prefix ";
  propagatedBuildInputs = [ qt4 libsamplerate fftwSinglePrec ];
  nativeBuildInputs = [ pkgconfig which cmake ];
  buildInputs = stdenv.lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.SystemConfiguration;

  meta = {
    homepage = https://github.com/lastfm/liblastfm;
    repositories.git = git://github.com/lastfm/liblastfm.git;
    description = "Official LastFM library";
    inherit (qt4.meta) platforms;
    maintainers = with stdenv.lib.maintainers; [ phreedom ];
  };
}
