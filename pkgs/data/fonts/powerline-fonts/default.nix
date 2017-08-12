{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "powerline-fonts-2017-05-25";

  src = fetchFromGitHub {
    owner = "powerline";
    repo = "fonts";
    rev = "fe396ef6f6b9b315f30af7d7229ff21f67a66e12";
    sha256 = "1l72kf0zqdp52hbnphky5cl0a1p9fghldvq7ppbnnrhmcwvavprs";
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
