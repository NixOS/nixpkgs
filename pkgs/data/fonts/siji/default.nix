{ stdenv, fetchzip, libfaketime, fonttosfnt, mkfontscale }:

stdenv.mkDerivation rec {
  name = "siji-${version}";
  version = "2016-05-13";

  src = fetchzip {
    url = https://github.com/stark/siji/archive/95369afac3e661cb6d3329ade5219992c88688c1.zip;
    sha256 = "1408g4nxwdd682vjqpmgv0cp0bfnzzzwls62cjs9zrds16xa9dpf";
  };

  nativeBuildInputs = [ libfaketime fonttosfnt mkfontscale ];

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

  postInstall = ''
    install -m 644 -D pcf/* -t "$out/share/fonts/misc"
    install -m 644 -D bdf/* -t "$bdf/share/fonts/misc"
    install -m 644 -D *.otb -t "$otb/share/fonts/misc"
    mkfontdir "$out/share/fonts/misc"
    mkfontdir "$bdf/share/fonts/misc"
    mkfontdir "$otb/share/fonts/misc"
  '';

  outputs = [ "out" "bdf" "otb" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/stark/siji;
    description = "An iconic bitmap font based on Stlarch with additional glyphs";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.asymmetric ];
  };
}
