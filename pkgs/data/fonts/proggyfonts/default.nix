{
  lib,
  stdenv,
  fetchurl,
  mkfontscale,
}:

stdenv.mkDerivation rec {
  pname = "proggyfonts";
  version = "0.1";

  src = fetchurl {
    url = "https://web.archive.org/web/20150801042353/http://kaictl.net/software/proggyfonts-${version}.tar.gz";
    hash = "sha256-SsLzZdR5icVJNbr5rcCPbagPPtWghbqs2Jxmrtufsa4=";
  };

  nativeBuildInputs = [ mkfontscale ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

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

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.upperbounds.net";
    description = "A set of fixed-width screen fonts that are designed for code listings";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.myrl ];
  };
}
