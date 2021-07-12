{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "meslo-lgs-nf";
  version = "2020-03-22";

  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "powerlevel10k-media";
    rev = "32c7d40239c93507277f14522be90b5750f442c9";
    sha256 = "10hq4whai1rqj495w4n80p0y21am8rihm4rc40xq7241d6dzilrd";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp $src/*.ttf $out/share/fonts/truetype
  '';

  meta = with lib; {
    description = "Meslo Nerd Font patched for Powerlevel10k";
    homepage = "https://github.com/romkatv/powerlevel10k-media";
    license = licenses.asl20;
    maintainers = with maintainers; [ bbigras ];
    platforms = platforms.all;
  };
}
