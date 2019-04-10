/* hunspell dictionaries */

{ stdenv, fetchurl, fetchFromGitHub, unzip, coreutils, bash, which, zip, ispell, perl, hunspell }:


let
  mkDict =
  { name, readmeFile, dictFileName, ... }@args:
  stdenv.mkDerivation (rec {
    inherit name;
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
  } // args);

  mkDictFromRla =
    { shortName, shortDescription, dictFileName }:
    mkDict rec {
      inherit dictFileName;
      version = "2.2";
      name = "hunspell-dict-${shortName}-rla-${version}";
      readmeFile = "README.txt";
      src = fetchFromGitHub {
        owner = "sbosio";
        repo = "rla-es";
        rev = "v${version}";
        sha256 = "0n9ms092k7vg7xpd3ksadxydbrizkb7js7dfxr08nbnnb9fgy0i8";
      };
      meta = with stdenv.lib; {
        description = "Hunspell dictionary for ${shortDescription} from rla";
        homepage = https://github.com/sbosio/rla-es;
        license = with licenses; [ gpl3 lgpl3 mpl11 ];
        maintainers = with maintainers; [ renzo ];
        platforms = platforms.all;
      };
      phases = "unpackPhase patchPhase buildPhase installPhase";
      buildInputs = [ bash coreutils unzip which zip ];
      patchPhase = ''
        substituteInPlace ortograf/herramientas/make_dict.sh \
           --replace /bin/bash bash \
           --replace /dev/stderr stderr.log

        substituteInPlace ortograf/herramientas/remover_comentarios.sh \
           --replace /bin/bash bash \
      '';
      buildPhase = ''
        cd ortograf/herramientas
        bash -x ./make_dict.sh -l ${dictFileName} -2
        unzip ${dictFileName}.zip \
          ${dictFileName}.dic ${dictFileName}.aff ${readmeFile}
      '';
    };

  mkDictFromDSSO =
    { shortName, shortDescription, dictFileName }:
    mkDict rec {
      inherit dictFileName;
      version = "2.40";
      # Should really use a string function or something
      _version = "2-40";
      name = "hunspell-dict-${shortName}-dsso-${version}";
      _name = "ooo_swedish_dict_${_version}";
      readmeFile = "LICENSE_en_US.txt";
      src = fetchurl {
        url = "https://extensions.libreoffice.org/extensions/swedish-spelling-dictionary-den-stora-svenska-ordlistan/${version}/@@download/file/${_name}.oxt";
        sha256 = "b982881cc75f5c4af1199535bd4735ee476bdc48edf63e3f05fb4f715654a7bc";
      };
      meta = with stdenv.lib; {
        longDescription = ''
        Svensk ordlista baserad på DSSO (den stora svenska ordlistan) och Göran
        Anderssons (goran@init.se) arbete med denna. Ordlistan hämtas från
        LibreOffice då dsso.se inte längre verkar vara med oss.
        '';
        description = "Hunspell dictionary for ${shortDescription} from LibreOffice";
        license = licenses.lgpl3;
        platforms = platforms.all;
      };
      buildInputs = [ unzip ];
      phases = "unpackPhase installPhase";
      sourceRoot = ".";
      unpackCmd = ''
      unzip $src dictionaries/${dictFileName}.dic dictionaries/${dictFileName}.aff $readmeFile
      '';
      installPhase = ''
        # hunspell dicts
        install -dm755 "$out/share/hunspell"
        install -m644 dictionaries/${dictFileName}.dic "$out/share/hunspell/"
        install -m644 dictionaries/${dictFileName}.aff "$out/share/hunspell/"
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
        homepage = https://www.dicollecte.org/home.php?prj=fr;
        license = licenses.mpl20;
        maintainers = with maintainers; [ renzo ];
        platforms = platforms.all;
      };
      buildInputs = [ unzip ];
      phases = "unpackPhase installPhase";
      sourceRoot = ".";
      unpackCmd = ''
        unzip $src ${dictFileName}.dic ${dictFileName}.aff ${readmeFile}
      '';
    };

  mkDictFromWordlist =
    { shortName, shortDescription, dictFileName, src }:
    mkDict rec {
      inherit src dictFileName;
      version = "2018.04.16";
      name = "hunspell-dict-${shortName}-wordlist-${version}";
      readmeFile = "README_" + dictFileName + ".txt";
      meta = with stdenv.lib; {
        description = "Hunspell dictionary for ${shortDescription} from Wordlist";
        homepage = http://wordlist.aspell.net/;
        license = licenses.bsd3;
        maintainers = with maintainers; [ renzo ];
        platforms = platforms.all;
      };
      buildInputs = [ unzip ];
      phases = "unpackPhase installPhase";
      sourceRoot = ".";
      unpackCmd = ''
        unzip $src ${dictFileName}.dic ${dictFileName}.aff ${readmeFile}
      '';
    };

  mkDictFromLinguistico =
    { shortName, shortDescription, dictFileName, src }:
    mkDict rec {
      inherit src dictFileName;
      version = "2.4";
      name = "hunspell-dict-${shortName}-linguistico-${version}";
      readmeFile = dictFileName + "_README.txt";
      meta = with stdenv.lib; {
        description = "Hunspell dictionary for ${shortDescription}";
        homepage = https://sourceforge.net/projects/linguistico/;
        license = licenses.gpl3;
        maintainers = with maintainers; [ renzo ];
        platforms = platforms.all;
      };
      buildInputs = [ unzip ];
      phases = "unpackPhase patchPhase installPhase";
      sourceRoot = ".";
      prePatch = ''
        # Fix dic file empty lines (FS#22275)
        sed '/^\/$/d' -i ${dictFileName}.dic
      '';
      unpackCmd = ''
        unzip $src ${dictFileName}.dic ${dictFileName}.aff ${readmeFile}
      '';
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

  mkDictFromJ3e =
    { shortName, shortDescription, dictFileName }:
    stdenv.mkDerivation rec {
      name = "hunspell-dict-${shortName}-j3e-${version}";
      version = "20161207";

      src = fetchurl {
        url = "https://j3e.de/ispell/igerman98/dict/igerman98-${version}.tar.bz2";
        sha256 = "1a3055hp2bc4q4nlg3gmg0147p3a1zlfnc65xiv2v9pyql1nya8p";
      };

      buildInputs = [ ispell perl hunspell ];

      phases = ["unpackPhase" "installPhase"];
      installPhase = ''
        patchShebangs bin
        make hunspell/${dictFileName}.aff hunspell/${dictFileName}.dic
        # hunspell dicts
        install -dm755 "$out/share/hunspell"
        install -m644 hunspell/${dictFileName}.dic "$out/share/hunspell/"
        install -m644 hunspell/${dictFileName}.aff "$out/share/hunspell/"
        # myspell dicts symlinks
        install -dm755 "$out/share/myspell/dicts"
        ln -sv "$out/share/hunspell/${dictFileName}.dic" "$out/share/myspell/dicts/"
        ln -sv "$out/share/hunspell/${dictFileName}.aff" "$out/share/myspell/dicts/"
      '';

      meta = with stdenv.lib; {
        homepage = https://www.j3e.de/ispell/igerman98/index_en.html;
        description = shortDescription;
        license = with licenses; [ gpl2 gpl3 ];
        maintainers = with maintainers; [ timor ];
        platforms = platforms.all;
      };
    };

  mkDictFromLibreOffice =
    { shortName
    , shortDescription
    , dictFileName
    , license
    , readmeFile ? "README_${dictFileName}.txt"
    , sourceRoot ? dictFileName }:
    mkDict rec {
      name = "hunspell-dict-${shortName}-libreoffice-${version}";
      version = "6.2.0.3";
      inherit dictFileName readmeFile;
      src = fetchFromGitHub {
        owner = "LibreOffice";
        repo = "dictionaries";
        rev = "libreoffice-${version}";
        sha256 = "0rw9ahhynia5wsgyd67lrhinqqn1s1rizgiykb3palbyk0lv72xj";
      };
      buildPhase = ''
        cp -a ${sourceRoot}/* .
      '';
      meta = with stdenv.lib; {
        homepage = https://wiki.documentfoundation.org/Development/Dictionaries;
        description = "Hunspell dictionary for ${shortDescription} from LibreOffice";
        license = license;
        maintainers = with maintainers; [ vlaci ];
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
      url = mirror://sourceforge/wordlist/speller/2018.04.16/hunspell-en_US-2018.04.16.zip;
      sha256 = "18hbncvqnckzqarrmnzk58plymjqyi93k4qj98fac5mr71jbmzaf";
    };
  };

  en-ca = mkDictFromWordlist {
    shortName = "en-ca";
    shortDescription = "English (Canada)";
    dictFileName = "en_CA";
    src = fetchurl {
      url = mirror://sourceforge/wordlist/speller/2018.04.16/hunspell-en_CA-2018.04.16.zip;
      sha256 = "06yf3s7y1215jmikbs18cn4j8a13csp4763w3jfgah8zlim6vc47";
    };
  };

  en-gb-ise = mkDictFromWordlist {
    shortName = "en-gb-ise";
    shortDescription = "English (United Kingdom, 'ise' ending)";
    dictFileName = "en_GB-ise";
    src = fetchurl {
      url = mirror://sourceforge/wordlist/speller//hunspell-en_GB-ise-2018.04.16.zip;
      sha256 = "0ylg1zvfvsawamymcc9ivrqcb9qhlpgpnizm076xc56jz554xc2l";
    };
  };

  en-gb-ize = mkDictFromWordlist {
    shortName = "en-gb-ize";
    shortDescription = "English (United Kingdom, 'ize' ending)";
    dictFileName = "en_GB-ize";
    src = fetchurl {
      url = mirror://sourceforge/wordlist/speller//hunspell-en_GB-ize-2018.04.16.zip;
      sha256 = "1rmwy6sxmd400cwjf58az6g14sq28p18f5mlq8ybg8y33q9m42ps";
    };
  };

  /* SPANISH */

  es-any = mkDictFromRla {
    shortName = "es-any";
    shortDescription = "Spanish (any variant)";
    dictFileName = "es_ANY";
  };

  es-ar = mkDictFromRla {
    shortName = "es-ar";
    shortDescription = "Spanish (Argentina)";
    dictFileName = "es_AR";
  };

  es-bo = mkDictFromRla {
    shortName = "es-bo";
    shortDescription = "Spanish (Bolivia)";
    dictFileName = "es_BO";
  };

  es-cl = mkDictFromRla {
    shortName = "es-cl";
    shortDescription = "Spanish (Chile)";
    dictFileName = "es_CL";
  };

  es-co = mkDictFromRla {
    shortName = "es-co";
    shortDescription = "Spanish (Colombia)";
    dictFileName = "es_CO";
  };

  es-cr = mkDictFromRla {
    shortName = "es-cr";
    shortDescription = "Spanish (Costra Rica)";
    dictFileName = "es_CR";
  };

  es-cu = mkDictFromRla {
    shortName = "es-cu";
    shortDescription = "Spanish (Cuba)";
    dictFileName = "es_CU";
  };

  es-do = mkDictFromRla {
    shortName = "es-do";
    shortDescription = "Spanish (Dominican Republic)";
    dictFileName = "es_DO";
  };

  es-ec = mkDictFromRla {
    shortName = "es-ec";
    shortDescription = "Spanish (Ecuador)";
    dictFileName = "es_EC";
  };

  es-es = mkDictFromRla {
    shortName = "es-es";
    shortDescription = "Spanish (Spain)";
    dictFileName = "es_ES";
  };

  es-gt = mkDictFromRla {
    shortName = "es-gt";
    shortDescription = "Spanish (Guatemala)";
    dictFileName = "es_GT";
  };

  es-hn = mkDictFromRla {
    shortName = "es-hn";
    shortDescription = "Spanish (Honduras)";
    dictFileName = "es_HN";
  };

  es-mx = mkDictFromRla {
    shortName = "es-mx";
    shortDescription = "Spanish (Mexico)";
    dictFileName = "es_MX";
  };

  es-ni = mkDictFromRla {
    shortName = "es-ni";
    shortDescription = "Spanish (Nicaragua)";
    dictFileName = "es_NI";
  };

  es-pa = mkDictFromRla {
    shortName = "es-pa";
    shortDescription = "Spanish (Panama)";
    dictFileName = "es_PA";
  };

  es-pe = mkDictFromRla {
    shortName = "es-pe";
    shortDescription = "Spanish (Peru)";
    dictFileName = "es_PE";
  };

  es-pr = mkDictFromRla {
    shortName = "es-pr";
    shortDescription = "Spanish (Puerto Rico)";
    dictFileName = "es_PR";
  };

  es-py = mkDictFromRla {
    shortName = "es-py";
    shortDescription = "Spanish (Paraguay)";
    dictFileName = "es_PY";
  };

  es-sv = mkDictFromRla {
    shortName = "es-sv";
    shortDescription = "Spanish (El Salvador)";
    dictFileName = "es_SV";
  };

  es-uy = mkDictFromRla {
    shortName = "es-uy";
    shortDescription = "Spanish (Uruguay)";
    dictFileName = "es_UY";
  };

  es-ve = mkDictFromRla {
    shortName = "es-ve";
    shortDescription = "Spanish (Venezuela)";
    dictFileName = "es_VE";
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

  it-it =  mkDictFromLinguistico rec {
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

  /* HUNGARIAN */

  hu-hu = mkDictFromLibreOffice {
    shortName = "hu-hu";
    dictFileName = "hu_HU";
    shortDescription = "Hungarian (Hungary)";
    license = with stdenv.lib.licenses; [ mpl20 lgpl3 ];
  };

  /* SWEDISH */
  
  sv-se = mkDictFromDSSO rec {
    shortName = "sv-se";
    dictFileName = "sv_SE";
    shortDescription = "Swedish (Sweden)";
  };

  # Finlandian Swedish (hello Linus Torvalds)
  sv-fi = mkDictFromDSSO rec {
    shortName = "sv-fi";
    dictFileName = "sv_FI";
    shortDescription = "Swedish (Finland)";
  };
  
  /* GERMAN */

  de-de = mkDictFromJ3e {
    shortName = "de-de";
    shortDescription = "German (Germany)";
    dictFileName = "de_DE";
  };

  de-at = mkDictFromJ3e {
    shortName = "de-at";
    shortDescription = "German (Austria)";
    dictFileName = "de_AT";
  };

  de-ch = mkDictFromJ3e {
    shortName = "de-ch";
    shortDescription = "German (Switzerland)";
    dictFileName = "de_CH";
  };
}
