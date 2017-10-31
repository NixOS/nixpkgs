{stdenv, fetchzip}:

fetchzip {
  name = "ttf-bitstream-vera-1.10";

  url = mirror://gnome/sources/ttf-bitstream-vera/1.10/ttf-bitstream-vera-1.10.tar.bz2;

  postFetch = ''
    tar -xjf $downloadedFile --strip-components=1
    fontDir=$out/share/fonts/truetype
    mkdir -p $fontDir
    cp *.ttf $fontDir
  '';

  sha256 = "179hal4yi3367jg8rsvqx6h2w4s0kn9zzrv8c47sslyg28g39s4m";

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
