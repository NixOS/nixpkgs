{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "nixos-artwork-2015-02-27";
  # Remember to check the default lightdm wallpaper when updating

  GnomeDark = fetchurl {
    url = https://raw.githubusercontent.com/NixOS/nixos-artwork/7ece5356398db14b5513392be4b31f8aedbb85a2/gnome/Gnome_Dark.png;
    sha256 = "0c7sl9k4zdjwvdz3nhlm8i4qv4cjr0qagalaa1a438jigixx27l7";
  };

  unpackPhase = "true";

  installPhase = ''
    mkdir -p $out/share/artwork/gnome
    ln -s $GnomeDark $out/share/artwork/gnome/Gnome_Dark.png
  '';
  
  meta = with stdenv.lib; {
    homepage = https://github.com/NixOS/nixos-artwork;
    platforms = platforms.all;
  };
}
