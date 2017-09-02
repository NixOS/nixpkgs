{stdenv, fetchzip, lib}:

let
  fonts = {
    symbola = { version = "9.17"; file = "Symbola.zip"; sha256 = "13z18lxx0py54nns61ihgxacpf1lg9s7g2sbpbnxpllqw7j73iq2";
                description = "Basic Latin, Greek, Cyrillic and many Symbol blocks of Unicode"; };
    aegyptus = { version = "6.17"; file = "Aegyptus.zip"; sha256 = "19rkf89msqb076qjdfa75pqrx35c3slj64vxw08zqdvyavq7jc79";
                 description = "Egyptian Hieroglyphs, Coptic, Meroitic"; };
    akkadian = { version = "7.17"; file = "AkkadianAssyrian.zip"; sha256 = "1xw2flrwb5r89sk7jd195v3svsb21brf1li2i3pdjcfqxfp5m0g7";
                 description = "Sumero-Akkadian Cuneiform"; };
    anatolian = { version = "5.17"; file = "Anatolian.zip"; sha256 = "0dqcyjakc4fy076pjplm6psl8drpwxiwyq97xrf6a3qa098gc0qc";
                  description = "Anatolian Hieroglyphs"; };
    maya = { version = "4.17"; file = "Maya.zip"; sha256 = "17s5c23wpqrcq5h6pgssbmzxiv4jvhdh2ssr99j9q6j32a51h9gh";
             description = "Maya Hieroglyphs"; };
    unidings = { version = "9.17"; file = "Unidings.zip"; sha256 = "0nzw8mrhk0hbjnl2cgi31b00vmi785win86kiz9d2yzdfz1is6sk";
                 description = "Glyphs and Icons for blocks of The Unicode Standard"; };
    musica = { version = "3.17"; file = "Musica.zip"; sha256 = "0mnv61dxzs2npvxgs5l9q81q19xzzi1sn53x5qwpiirkmi6bg5y6";
               description = "Musical Notation"; };
    analecta = { version = "5.17"; file = "Analecta.zip"; sha256 = "13npnfscd9mz6vf89qxxbj383njf53a1smqjh0c1w2lvijgak3aj";
                 description = "Coptic, Gothic, Deseret"; };
    textfonts = { version = "7.17"; file = "TextfontsFonts.zip"; sha256 = "1ggflqnslp81v8pzmzx6iwi2sa38l9bpivjjci7nvx3y5xynm6wl";
                 description = "Aroania, Anaktoria, Alexander, Avdira and Asea"; };
    aegan = { version = "9.17"; file = "AegeanFonts.zip"; sha256 = "0dm2ck3p11bc9izrh7xz3blqfqg1mgsvy4jsgmz9rcs4m74xrhsf";
              description = "Aegean"; };
    abydos = { version = "1.23"; file = "AbydosFont.zip"; sha256 = "04r7ysnjjq0nrr3m8lbz8ssyx6xaikqybjqxzl3ziywl9h6nxdj8";
               description = "AbydosFont"; };
  };

  mkpkg = name_: {version, file, sha256, description}: fetchzip rec {
    name = "${name_}-${version}";
    url = "http://users.teilar.gr/~g1951d/${file}";
    postFetch = ''
      mkdir -p $out/share/{fonts,doc}
      unzip -j $downloadedFile \*.ttf                 -d $out/share/fonts/truetype
      unzip -j $downloadedFile \*.docx \*.pdf \*.xlsx -d "$out/share/doc/${name}" || true  # unpack docs if any
      rmdir "$out/share/doc/${name}" $out/share/doc                               || true  # remove dirs if empty
    '';
    inherit sha256;

    meta = {
      inherit description;
      # In lieu of a license:
      # Fonts in this site are offered free for any use;
      # they may be installed, embedded, opened, edited, modified, regenerated, posted, packaged and redistributed.
      license = stdenv.lib.licenses.free;
      homepage = http://users.teilar.gr/~g1951d/;
      platforms = stdenv.lib.platforms.unix;
    };
  };
in
  lib.mapAttrs mkpkg fonts
