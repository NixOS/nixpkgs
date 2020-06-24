{ lib, mkFont, fetchzip, libfaketime, fonttosfnt, mkfontscale }:

mkFont rec {
  pname = "siji";
  version = "2016-05-13";

  src = fetchzip {
    url = "https://github.com/stark/siji/archive/95369afac3e661cb6d3329ade5219992c88688c1.zip";
    sha256 = "1408g4nxwdd682vjqpmgv0cp0bfnzzzwls62cjs9zrds16xa9dpf";
  };

  nativeBuildInputs = [ libfaketime fonttosfnt mkfontscale ];

  dontBuild = false;
  buildPhase = ''
    # compress pcf fonts
    gzip -n -9 pcf/*

    # convert bdf fonts to otb
    for i in bdf/*; do
        name=$(basename $i .bdf)
        faketime -f "1970-01-01 00:00:01" \
        fonttosfnt -v -o "$name.otb" "$i"
    done
  '';

  meta = with lib; {
    homepage = "https://github.com/stark/siji";
    description = "An iconic bitmap font based on Stlarch with additional glyphs";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ asymmetric ];
  };
}
