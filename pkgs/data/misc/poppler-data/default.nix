{ fetchurl, stdenv, cmake }:

stdenv.mkDerivation rec {
  name = "poppler-data-0.4.7";

  src = fetchurl {
    url = "http://poppler.freedesktop.org/${name}.tar.gz";
    sha256 = "1pm7wg6xqj4sppb5az4pa7psfdk4yxxkw52j85bm9fksibcb0lp7";
  };

  buildInputs = [ cmake ];

# TODO: actually use $prefix/etc/profile.d in NixOS
  postInstall =
    ''
      mkdir -pv ''${out}/etc/profile.d
      echo "export POPPLER_DATADIR=''${out}/share/poppler" |
        tee ''${out}/etc/profile.d/60-poppler.sh
      chmod -c +x ''${out}/etc/profile.d/60-poppler.sh
    '';

  meta = {
    homepage = http://poppler.freedesktop.org/;
    description = "Encoding files for Poppler, a PDF rendering library";
    platforms = stdenv.lib.platforms.all;
    license = "free"; # more free licenses combined
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
