{ lib, fetchzip }:

fetchzip {
  name = "bakoma-ttf";

  url = http://tarballs.nixos.org/sha256/1j1y3cq6ys30m734axc0brdm2q9n2as4h32jws15r7w5fwr991km;

  postFetch = ''
    tar xjvf $downloadedFile --strip-components=1
    mkdir -p $out/share/fonts/truetype
    cp ttf/*.ttf $out/share/fonts/truetype
  '';

  sha256 = "0g7i723n00cqx2va05z1h6v3a2ar69gqw4hy6pjj7m0ml906rngc";

  meta = {
    description = "TrueType versions of the Computer Modern and AMS TeX Fonts";
    homepage = http://www.ctan.org/tex-archive/fonts/cm/ps-type1/bakoma/ttf/;
  };
}
