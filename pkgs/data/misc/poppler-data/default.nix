{ fetchurl, stdenv, cmake }:

stdenv.mkDerivation rec {
  name = "poppler-data-0.4.3";

  src = fetchurl {
    url = "http://poppler.freedesktop.org/${name}.tar.gz";
    sha256 = "19jq5miinzzrzlv6696j82hr60ga2r4msk6a34s9537vid410q22";
  };

  buildInputs = [ cmake ];

  postInstall = ''
    ensureDir ''${out}/etc/profile.d
    echo "export POPPLER_DATADIR=''${out}/share/poppler" > \
      ''${out}/etc/profile.d/60-poppler.sh
  '';

  meta = {
    homepage = http://poppler.freedesktop.org/;
    description = "Encoding files for Poppler, a PDF rendering library";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
