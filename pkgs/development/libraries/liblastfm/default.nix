{ stdenv, fetchurl, ruby, qt4, pkgconfig, libsamplerate, fftwSinglePrec, which }:

let version = "0.3.3"; in

stdenv.mkDerivation rec {
  name = "liblastfm-${version}";

  # Upstream does not package git tags as tarballs. Get tarball from github.
  src = fetchurl {
    url = "https://github.com/mxcl/liblastfm/tarball/${version}";
    name = "${name}.tar.gz";
    sha256 = "0v33vzj89mgx2pc5fmiywlz51i553ckydw9xz70fiflm2inbl1r6";
  };

  prefixKey = "--prefix ";
  propagatedBuildInputs = [ qt4 libsamplerate fftwSinglePrec ];
  buildNativeInputs = [ ruby pkgconfig which ];

  configureFlags = "--release";

  patches = [ ./ruby-1.9.patch ];
  postPatch = "patchShebangs .";

  meta = {
    homepage = http://github.com/mxcl/liblastfm;
    description = "Official LastFM library";
    inherit (qt4.meta) platforms;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
