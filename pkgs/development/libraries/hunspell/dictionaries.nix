/* hunspell dictionaries */

{ stdenv, fetchurl, unzip }:

with stdenv.lib;

let

  mkDict =
  { name, src, meta, readmeFile, dictFileName, ... }:
  let
    isFrench = hasSuffix "fr_" dictFileName;
    isItaly = hasSuffix "it_" dictFileName;
    isSpanish = hasSuffix "es_" dictFileName;
    isEnglish = hasSuffix "en_" dictFileName;
  in
  stdenv.mkDerivation rec {
    inherit name src meta;
    buildInputs = [ unzip ];
    sourceRoot = ".";
    phases = "unpackPhase installPhase" + (if isItaly then "patchPhase" else "");
    unpackCmd = "unzip $src ${readmeFile} ${dictFileName}.dic ${dictFileName}.aff";
    prePatch = if isItaly then ''
    # Fix dic file empty lines (FS#22275)
    sed '/^\/$/d' -i it_IT.dic
    '' else "";

    installPhase = ''
      # hunspell dicts
      install -dm755 "$out/share/hunspell"
      install -m644 ${dictFileName}.dic "$out/share/hunspell/"
      install -m644 ${dictFileName}.aff "$out/share/hunspell/"
      # myspell dicts symlinks
      install -dm755 "$out/share/myspell/dicts"
      ln -sv "$out/share/hunspell/${dictFileName}.dic" "$out/share/myspell/dicts/"
      ln -sv "$out/share/hunspell/${dictFileName}.aff" "$out/share/myspell/dicts/"
      # docs
      install -dm755 "$out/share/doc"
      install -m644 ${readmeFile} $out/share/doc/${name}.txt
    '';
  };

  mkDictFromDicollecte =
    { shortName, shortDescription, longDescription, dictFileName }:
    mkDict rec {
      inherit dictFileName;
      version = "5.3";
      name = "hunspell-dict-${shortName}-dicollecte-${version}";
      readmeFile = "README_dict_fr.txt";
      src = fetchurl {
         url = "http://www.dicollecte.org/download/fr/hunspell-french-dictionaries-v${version}.zip";
         sha256 = "0ca7084jm7zb1ikwzh1frvpb97jn27i7a5d48288h2qlfp068ik0";
      };
      meta = with stdenv.lib; {
        inherit longDescription;
        description = "Hunspell dictionary for ${shortDescription} from Dicollecte";
        homepage = "http://www.dicollecte.org/home.php?prj=fr";
        license = licenses.mpl20;
        maintainers = with maintainers; [ renzo ];
        platforms = platforms.all;
      };
    };

  mkDictFromWordlist =
    { shortName, shortDescription, dictFileName, src }:
    mkDict rec {
      inherit src dictFileName;
      version = "2014.11.17";
      name = "hunspell-dict-${shortName}-wordlist-${version}";
      readmeFile = "README_" + dictFileName + ".txt";
      meta = with stdenv.lib; {
        description = "Hunspell dictionary for ${shortDescription} from Wordlist";
        homepage = http://wordlist.aspell.net/;
        license = licenses.bsd3;
        maintainers = with maintainers; [ renzo ];
        platforms = platforms.all;
      };
    };

  mkLinguistico =
    { shortName, shortDescription, dictFileName, src }:
    mkDict rec {
      inherit src dictFileName;
      version = "2.4";
      name = "hunspell-dict-${shortName}-linguistico-${version}";
      readmeFile = dictFileName + "_README.txt";
      meta = with stdenv.lib; {
        homepage = http://sourceforge.net/projects/linguistico/;
        license = licenses.gpl3;
        maintainers = with maintainers; [ renzo ];
        platforms = platforms.all;
      };
    };

  mkDictFromXuxen =
    { shortName, srcs, shortDescription, longDescription, dictFileName }:
    stdenv.mkDerivation rec {
      name = "hunspell-dict-${shortName}-xuxen-${version}";
      version = "5-2015.11.10";

      inherit srcs;

      phases = ["unpackPhase" "installPhase"];
      sourceRoot = ".";
      # Copy files stripping until first dash (path and hash)
      unpackCmd = "cp $curSrc \${curSrc##*-}";
      installPhase = ''
        # hunspell dicts
        install -dm755 "$out/share/hunspell"
        install -m644 ${dictFileName}.dic "$out/share/hunspell/"
        install -m644 ${dictFileName}.aff "$out/share/hunspell/"
        # myspell dicts symlinks
        install -dm755 "$out/share/myspell/dicts"
        ln -sv "$out/share/hunspell/${dictFileName}.dic" "$out/share/myspell/dicts/"
        ln -sv "$out/share/hunspell/${dictFileName}.aff" "$out/share/myspell/dicts/"
      '';

      meta = with stdenv.lib; {
        homepage = http://xuxen.eus/;
        description = shortDescription;
        longDescription = longDescription;
        license = licenses.gpl2;
        maintainers = with maintainers; [ zalakain ];
        platforms = platforms.all;
      };
    };

in {

  /* ENGLISH */

  en-us = mkDictFromWordlist {
    shortName = "en-us";
    shortDescription = "English (United States)";
    dictFileName = "en_US";
    src = fetchurl {
      url = mirror://sourceforge/wordlist/speller/2014.11.17/hunspell-en_US-2014.11.17.zip;
      sha256 = "4ce88a1af457ce0e256110277a150e5da798213f611929438db059c1c81e20f2";
    };
  };

  en-ca = mkDictFromWordlist {
    shortName = "en-ca";
    shortDescription = "English (Canada)";
    dictFileName = "en_CA";
    src = fetchurl {
      url = mirror://sourceforge/wordlist/speller/2014.11.17/hunspell-en_CA-2014.11.17.zip;
      sha256 = "59950448440657a6fc3ede15720c1b86c0b66c4ec734bf1bd9157f6a1786673b";
    };
  };

  en-gb-ise = mkDictFromWordlist {
    shortName = "en-gb-ise";
    shortDescription = "English (United Kingdom, 'ise' ending)";
    dictFileName = "en_GB-ise";
    src = fetchurl {
      url = mirror://sourceforge/wordlist/speller/2014.11.17/hunspell-en_GB-ise-2014.11.17.zip;
      sha256 = "97f3b25102fcadd626ae4af3cdd97f017ce39264494f98b1f36ad7d96b9d5a94";
    };
  };

  en-gb-ize = mkDictFromWordlist {
    shortName = "en-gb-ize";
    shortDescription = "English (United Kingdom, 'ize' ending)";
    dictFileName = "en_GB-ize";
    src = fetchurl {
      url = mirror://sourceforge/wordlist/speller/2014.11.17/hunspell-en_GB-ize-2014.11.17.zip;
      sha256 = "84270673ed7c014445f3ba02f9efdb0ac44cea9ee0bfec76e3e10feae55c4e1c";
    };
  };

  /* FRENCH */

  fr-any = mkDictFromDicollecte {
    shortName = "fr-any";
    dictFileName = "fr-toutesvariantes";
    shortDescription = "French (any variant)";
    longDescription = ''
      Ce dictionnaire contient les nouvelles et les anciennes graphies des
      mots concernés par la réforme de 1990.
    '';
  };

  fr-classique = mkDictFromDicollecte {
    shortName = "fr-classique";
    dictFileName = "fr-classique";
    shortDescription = "French (classic)";
    longDescription = ''
      Ce dictionnaire est une extension du dictionnaire «Moderne» et propose
      en sus des graphies alternatives, parfois encore très usitées, parfois
      tombées en désuétude.
    '';
  };

  fr-moderne = mkDictFromDicollecte {
    shortName = "fr-moderne";
    dictFileName = "fr-moderne";
    shortDescription = "French (modern)";
    longDescription = ''
      Ce dictionnaire propose une sélection des graphies classiques et
      réformées, suivant la lente évolution de l’orthographe actuelle. Ce
      dictionnaire contient les graphies les moins polémiques de la réforme.
    '';
  };

  fr-reforme1990 = mkDictFromDicollecte {
    shortName = "fr-reforme1990";
    dictFileName = "fr-reforme1990";
    shortDescription = "French (1990 reform)";
    longDescription = ''
      Ce dictionnaire ne connaît que les graphies nouvelles des mots concernés
      par la réforme de 1990.
    '';
  };

  /* ITALIAN */

  it-it =  mkLinguistico rec {
    shortName = "it-it";
    dictFileName = "it_IT";
    shortDescription = "Hunspell dictionary for 'Italian (Italy)' from Linguistico";
    src = fetchurl {
      url = mirror://sourceforge/linguistico/italiano_2_4_2007_09_01.zip;
      sha256 = "0m9frz75fx456bczknay5i446gdcp1smm48lc0qfwzhz0j3zcdrd";
    };
  };

  /* BASQUE */

  eu-es = mkDictFromXuxen {
    shortName = "eu-es";
    dictFileName = "eu_ES";
    shortDescription = "Basque (Xuxen 5)";
    longDescription = ''
      Itxura berritzeaz gain, testuak zuzentzen laguntzeko zenbait hobekuntza
      egin dira Xuxen.eus-en. Lexikoari dagokionez, 18645 sarrera berri erantsi
      ditugu, eta proposamenak egiteko sistema ere aldatu dugu. Esate baterako,
      gaizki idatzitako hitz baten inguruko proposamenak eskuratzeko, euskaraz
      idaztean egiten ditugun akats arruntenak hartu dira kontuan. Sistemak
      ematen dituen proposamenak ordenatzeko, berriz, aipatutako irizpidea
      erabiltzeaz gain, Internetetik automatikoki eskuratutako euskarazko corpus
      bateko datuen arabera ordenatu daitezke emaitzak. Erabiltzaileak horrela
      ordenatu nahi baditu proposamenak, hautatu egin behar du aukera hori
      testu-kutxaren azpian dituen aukeren artean. Interesgarria da proposamenak
      ordenatzeko irizpide hori, hala sistemak formarik erabilienak proposatuko
      baitizkigu gutxiago erabiltzen direnen aurretik.
    '';
    srcs = [
      (fetchurl {
        url = "http://xuxen.eus/static/hunspell/eu_ES.aff";
        sha256 = "12w2j6phzas2rdzc7f20jnk93sm59m2zzfdgxv6p8nvcvbrkmc02";
      })
      (fetchurl {
        url = "http://xuxen.eus/static/hunspell/eu_ES.dic";
        sha256 = "0lw193jr7ldvln5x5z9p21rz1by46h0say9whfcw2kxs9vprd5b3";
      })
    ];
  };
}
