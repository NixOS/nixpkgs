{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "meslo-lgs-nf";
  version = "2021-09-03";

  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "powerlevel10k-media";
    rev = "389133fb8c9a2347929a23702ce3039aacc46c3d";
    sha256 = "sha256-dWqRxjqsa/Tiv0Ww8VLHRDhftD3eqa1t2/T0irFeMFI=";
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
