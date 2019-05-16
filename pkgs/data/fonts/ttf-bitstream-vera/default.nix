{ lib, fetchzip }:

fetchzip {
  name = "ttf-bitstream-vera-1.10";

  url = mirror://gnome/sources/ttf-bitstream-vera/1.10/ttf-bitstream-vera-1.10.tar.bz2;

  postFetch = ''
    tar -xjf $downloadedFile --strip-components=1
    install -m444 -Dt $out/share/fonts/truetype *.ttf
  '';

  sha256 = "179hal4yi3367jg8rsvqx6h2w4s0kn9zzrv8c47sslyg28g39s4m";

  meta = {
  };
}
