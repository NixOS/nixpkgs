{ stdenv, fetchzip }:

fetchzip rec {
  name = "baekmuk-ttf-2.2";

  url = "http://kldp.net/baekmuk/release/865-${name}.tar.gz";
  postFetch = ''
    tar -xzvf $downloadedFile --strip-components=1
    mkdir -p $out/share/fonts $out/share/doc/${name}
    cp ttf/*.ttf  $out/share/fonts
    cp COPYRIGHT* $out/share/doc/${name}
  '';
  sha256 = "1jgsvack1l14q8lbcv4qhgbswi30mf045k37rl772hzcmx0r206g";

  meta = {
    description = "Korean font";
    homepage = http://kldp.net/projects/baekmuk/;
    license = "BSD-like";
    platforms = stdenv.lib.platforms.linux;
  };
}

