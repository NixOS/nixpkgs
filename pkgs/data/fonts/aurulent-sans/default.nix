{stdenv, fetchzip}:

fetchzip rec {
  name = "aurulent-sans-0.1";

  url = "https://github.com/deepfire/hartke-aurulent-sans/archive/${name}.zip";
  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
  '';
  sha256 = "1l60psfv9x0x9qx9vp1qnhmck7a7kks385m5ycrd3d91irz1j5li";

  meta = {
    description = "Aurulent Sans";
    longDescription = "Aurulent Sans is a humanist sans serif intended to be used as an interface font.";
    homepage = http://delubrum.org/;
    maintainers = with stdenv.lib.maintainers; [ deepfire ];
    license = stdenv.lib.licenses.ofl;
    platforms = stdenv.lib.platforms.all;
  };
}
