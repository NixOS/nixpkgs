{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "powerline-fonts-2015-06-29";

  src = fetchFromGitHub {
    owner = "powerline";
    repo = "fonts";
    rev = "97dc451724fb24e1dd9892c988642b239b5dc67c";
    sha256 = "1m0a8k916s74iv2k0kk36dz7d2hfb2zgf8m0b9hg71w4yd3bmj4w";
  };

  buildPhase = "true";

  installPhase =
    ''
      mkdir -p $out/share/fonts/opentype
      cp -v */*.otf $out/share/fonts/opentype

      mkdir -p $out/share/fonts/truetype
      cp -v */*.ttf $out/share/fonts/truetype
    '';

  meta = with stdenv.lib; {
    homepage = https://github.com/powerline/fonts;
    description = "Patched fonts for Powerline users";
    longDescription = ''
      Pre-patched and adjusted fonts for usage with the Powerline plugin.
    '';
    license = with licenses; [ asl20 free ofl ];
    platforms = platforms.all;
    maintainer = with maintainers; [ malyn ];
  };
}
