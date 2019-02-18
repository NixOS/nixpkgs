{ lib, fetchzip }:

let version = "2.0.0"; in
fetchzip rec {
  name = "luculent-${version}";
  url =  http://www.eastfarthing.com/luculent/luculent.tar.xz;

  postFetch = ''
    tar -xJf $downloadedFile --strip-components=1
    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype
  '';

  sha256 = "1m3g64galwna1xjxb1fczmfplm6c1fn3ra1ln7f0vkm0ah5m4lbv";

  meta = with lib; {
    description = "luculent font";
    homepage = http://www.eastfarthing.com/luculent/;
    license = licenses.ofl;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}
