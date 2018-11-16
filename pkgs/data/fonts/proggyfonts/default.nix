{ stdenv, fetchurl, mkfontdir, mkfontscale }:

# adapted from https://aur.archlinux.org/packages/proggyfonts/

stdenv.mkDerivation rec {
  name = "proggyfonts-0.1";

  src = fetchurl {
    url = "https://web.archive.org/web/20150801042353/http://kaictl.net/software/proggyfonts-0.1.tar.gz";
    sha256 = "1plcm1sjpa3hdqhhin48fq6zmz3ndm4md72916hd8ff0w6596q0n";
  };

  nativeBuildInputs = [ mkfontdir mkfontscale ];

  installPhase =
    ''
      mkdir -p $out/share/doc/$name $out/share/fonts/misc $out/share/fonts/truetype

      cp Licence.txt $out/share/doc/$name/LICENSE

      rm Speedy.pcf # duplicated as Speedy11.pcf
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
  outputHash = "1l1sxmzp3gcd2d32nxar6xwd1v1w18a9gfh57zmsrfpspnfbz7y1";

  meta = with stdenv.lib; {
    homepage = http://upperbounds.net;
    description = "A set of fixed-width screen fonts that are designed for code listings";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.myrl ];
  };
}
