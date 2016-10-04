{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "powerline-fonts-2015-12-11";

  src = fetchFromGitHub {
    owner = "powerline";
    repo = "fonts";
    rev = "a44abd0e742ad6e7fd8d8bc4c3cad5155c9f3a92";
    sha256 = "1pwz83yh28yd8aj6fbyfz8z3q3v67psszpd9mp4vv0ms9w8b5ajn";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    cp -v */*.otf $out/share/fonts/opentype

    mkdir -p $out/share/fonts/truetype
    cp -v */*.ttf $out/share/fonts/truetype

    mkdir -p $out/share/fonts/bdf
    cp -v */BDF/*.bdf $out/share/fonts/bdf

    mkdir -p $out/share/fonts/pcf
    cp -v */PCF/*.pcf.gz $out/share/fonts/pcf

    mkdir -p $out/share/fonts/psf
    cp -v */PSF/*.psf.gz $out/share/fonts/psf
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/powerline/fonts;
    description = "Patched fonts for Powerline users";
    longDescription = ''
      Pre-patched and adjusted fonts for usage with the Powerline plugin.
    '';
    license = with licenses; [ asl20 free ofl ];
    platforms = platforms.all;
    maintainers = with maintainers; [ malyn ];
  };
}
