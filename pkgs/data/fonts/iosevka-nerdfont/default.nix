{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "iosevka-nerdfont";
  version = "2021-04-25";

  src = fetchFromGitHub {
    owner = "ryanoasis";
    repo = "nerd-fonts";
    rev = "2d218ec31e98c959a368fb9bba45c0ee52103c87";
    sha256 = "18m0w5kwlidp5p5pfa06d0jr2kfqcbcs9223k0bs25sgigqikac5";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp $src/*.ttf $out/share/fonts/truetype
  '';

  meta = with lib; {
    description = "Iosevka Nerd Font";
    homepage = "https://github.com/ryanoasis/nerd-fonts";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
