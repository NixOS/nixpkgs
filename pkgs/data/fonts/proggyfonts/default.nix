{ stdenv, fetchurl, mkfontdir, mkfontscale }:

# adapted from https://aur.archlinux.org/packages/proggyfonts/

stdenv.mkDerivation rec {
  name = "proggyfonts-0.1";

  src = fetchurl {
    url = "http://web.archive.org/web/20150801042353/http://kaictl.net/software/proggyfonts-0.1.tar.gz";
    sha256 = "1plcm1sjpa3hdqhhin48fq6zmz3ndm4md72916hd8ff0w6596q0n";
  };

  buildInputs = [ mkfontdir mkfontscale ];

  installPhase =
    ''
      mkdir -p $out/share/doc/$name $out/share/fonts/misc $out/share/fonts/truetype

      cp Licence.txt $out/share/doc/$name/LICENSE

      for f in *.pcf; do
        gzip -c "$f" > $out/share/fonts/misc/"$f".gz
      done
      cp *.bdf $out/share/fonts/misc
      cp *.ttf $out/share/fonts/truetype

      for f in misc truetype; do
        cd $out/share/fonts/$f
        mkfontscale
        mkfontdir
      done
    '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "06jsf3rw6q4l1jrw1161h4vxa1xbvpry5x12d8sh5g7hjk88p77g";

  meta = with stdenv.lib; {
    homepage = http://upperbounds.net;
    description = "A set of fixed-width screen fonts that are designed for code listings";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.myrl ];
  };
}
