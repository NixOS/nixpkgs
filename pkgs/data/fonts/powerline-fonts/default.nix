{ lib, fetchFromGitHub }:

fetchFromGitHub {
  name = "powerline-fonts-2018-11-11";

  owner = "powerline";
  repo = "fonts";
  rev = "e80e3eba9091dac0655a0a77472e10f53e754bb0";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    find . -name '*.otf'    -exec install -Dt $out/share/fonts/opentype {} \;
    find . -name '*.ttf'    -exec install -Dt $out/share/fonts/truetype {} \;
    find . -name '*.bdf'    -exec install -Dt $out/share/fonts/bdf      {} \;
    find . -name '*.pcf.gz' -exec install -Dt $out/share/fonts/pcf      {} \;
    find . -name '*.psf.gz' -exec install -Dt $out/share/fonts/psf      {} \;
  '';

  sha256 = "0irifak86gn7hawzgxcy53s22y215mxc2kjncv37h7q44jsqdqww";

  meta = with lib; {
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
