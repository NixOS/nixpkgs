{ stdenv, fetchzip }:

fetchzip rec {
  name = "wqy-microhei-0.2.0-beta";

  url = "mirror://sourceforge/wqy/${name}.tar.gz";

  postFetch = ''
    tar -xzf $downloadedFile --strip-components=1
    install -Dm644 wqy-microhei.ttc $out/share/fonts/wqy-microhei.ttc
  '';

  sha256 = "0i5jh7mkp371fxqmsvn7say075r641yl4hq26isjyrqvb8cv92a9";

  meta = {
    description = "A (mainly) Chinese Unicode font";
    homepage = http://wenq.org;
    license = stdenv.lib.licenses.asl20;
    maintainers = [ stdenv.lib.maintainers.pkmx ];
    platforms = stdenv.lib.platforms.all;
  };
}

