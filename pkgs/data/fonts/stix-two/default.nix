{ stdenv, fetchFromGitHub }:

let
  version = "2.0.2";
in fetchFromGitHub {
  name = "stix-two-${version}";

  owner = "stipub";
  repo = "stixfonts";
  rev = "v${version}";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    install -m444 -Dt $out/share/fonts/opentype/ OTF/*.otf
    install -m444 -Dt $out/share/fonts/woff/     WOFF/*.woff
    install -m444 -Dt $out/share/fonts/woff2/    WOFF2/*.woff2
  '';

  sha256 = "1ah8s0cb67yv4ll8zfs01mdh9m5i2lbkrfbmkhi1xdid6pxsk32x";

  meta = with stdenv.lib; {
    homepage = "http://www.stixfonts.org/";
    description = "Fonts for Scientific and Technical Information eXchange";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.rycee ];
  };
}
