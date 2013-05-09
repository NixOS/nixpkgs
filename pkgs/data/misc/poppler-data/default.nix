{ fetchurl, stdenv, cmake }:

stdenv.mkDerivation rec {
  name = "poppler-data-0.4.5";

  src = fetchurl {
    url = "http://poppler.freedesktop.org/${name}.tar.gz";
    sha256 = "1zbh1zd083wfwrcw7vxc2bn32h42y6iyh24syxcb3r5ggd2vr41i";
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
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
