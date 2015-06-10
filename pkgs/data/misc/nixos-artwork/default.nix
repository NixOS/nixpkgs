{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "nixos-artwork-2015-02-27";
  # Remember to check the default lightdm wallpaper when updating

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "nixos-artwork";
    rev = "e71b6846023919136795ede22b16d73b2cf1693d";
    sha256 = "167yvhm2qy7qgyrqqs4hv98mmlarhgxpcsyv0r8a9g3vkblfdczb";
  };

  installPhase = ''
    mkdir -p $out/share/artwork
    cp -r * $out/share/artwork
    find $out -name \*.xcf -exec rm {} \;
  '';
  
  meta = with stdenv.lib; {
    homepage = "https://github.com/NixOS/nixos-artwork";
    platforms = platforms.all;
  };
}
