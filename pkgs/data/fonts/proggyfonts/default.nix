{ stdenv, fetchurl, mkfontscale }:

stdenv.mkDerivation {
  name = "proggyfonts-0.1";

  src = fetchurl {
    url = "https://web.archive.org/web/20150801042353/http://kaictl.net/software/proggyfonts-0.1.tar.gz";
    sha256 = "1plcm1sjpa3hdqhhin48fq6zmz3ndm4md72916hd8ff0w6596q0n";
  };

  nativeBuildInputs = [ mkfontscale ];

  installPhase =
    ''
      # compress pcf fonts
      mkdir -p $out/share/fonts/misc
      rm Speedy.pcf # duplicated as Speedy11.pcf
      for f in *.pcf; do
        gzip -n -9 -c "$f" > $out/share/fonts/misc/"$f".gz
      done

      install -D -m 644 *.bdf -t "$out/share/fonts/misc"
      install -D -m 644 *.ttf -t "$out/share/fonts/truetype"
      install -D -m 644 Licence.txt -t "$out/share/doc/$name"

      mkfontscale "$out/share/fonts/truetype"
      mkfontdir   "$out/share/fonts/misc"
    '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "1x196rp3wqjd7m57bgp5kfy5jmj97qncxi1vwibs925ji7dqzfgf";

  meta = with stdenv.lib; {
    homepage = http://upperbounds.net;
    description = "A set of fixed-width screen fonts that are designed for code listings";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.myrl ];
  };
}
