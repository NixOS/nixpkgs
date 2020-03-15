/* hunspell dictionaries */

{ stdenv, fetchurl, fetchFromGitHub, unzip, coreutils, bash, which, zip, ispell, perl, hunspell }:


let
  mkDict =
  { name, readmeFile, dictFileName, ... }@args:
  stdenv.mkDerivation ({
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
      runHook postInstall
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
    { shortName, shortDescription, longDescription, dictFileName, isDefault ? false }:
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
      postInstall = stdenv.lib.optionalString isDefault ''
        for ext in aff dic; do
          ln -sv $out/share/hunspell/${dictFileName}.$ext $out/share/hunspell/fr_FR.$ext
          ln -sv $out/share/myspell/dicts/${dictFileName}.$ext $out/share/myspell/dicts/fr_FR.$ext
        done
      '';
    };

  mkDictFromWordlist =
    { shortName, shortDescription, srcFileName, dictFileName, src }:
    mkDict rec {
      inherit src srcFileName dictFileName;
      version = "2018.04.16";
      name = "hunspell-dict-${shortName}-wordlist-${version}";
      srcReadmeFile = "README_" + srcFileName + ".txt";
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
        unzip $src ${srcFileName}.dic ${srcFileName}.aff ${srcReadmeFile}
      '';
      postUnpack = ''
        mv ${srcFileName}.dic ${dictFileName}.dic || true
        mv ${srcFileName}.aff ${dictFileName}.aff || true
        mv ${srcReadmeFile} ${readmeFile}         || true
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
      version = "6.3.0.4";
      inherit dictFileName readmeFile;
      src = fetchFromGitHub {
        owner = "LibreOffice";
        repo = "dictionaries";
        rev = "libreoffice-${version}";
        sha256 = "14z4b0grn7cw8l9s7sl6cgapbpwhn1b3gwc3kn6b0k4zl3dq7y63";
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

in rec {

  /* ENGLISH */

  en_US = en-us;
  en-us = mkDictFromWordlist {
    shortName = "en-us";
    shortDescription = "English (United States)";
    srcFileName = "en_US";
    dictFileName = "en_US";
    src = fetchurl {
      url = mirror://sourceforge/wordlist/speller/2018.04.16/hunspell-en_US-2018.04.16.zip;
      sha256 = "18hbncvqnckzqarrmnzk58plymjqyi93k4qj98fac5mr71jbmzaf";
    };
  };

  en_US-large = en-us-large;
  en-us-large = mkDictFromWordlist {
    shortName = "en-us-large";
    shortDescription = "English (United States) Large";
    srcFileName = "en_US-large";
    dictFileName = "en_US";
    src = fetchurl {
      url = mirror://sourceforge/wordlist/speller/2018.04.16/hunspell-en_US-large-2018.04.16.zip;
      sha256 = "1xm9jgqbivp5cb78ykjxg47vzq1yqj82l7r4q5cjpivrv99s49qc";
    };
  };

  en_CA = en-ca;
  en-ca = mkDictFromWordlist {
    shortName = "en-ca";
    shortDescription = "English (Canada)";
    srcFileName = "en_CA";
    dictFileName = "en_CA";
    src = fetchurl {
      url = mirror://sourceforge/wordlist/speller/2018.04.16/hunspell-en_CA-2018.04.16.zip;
      sha256 = "06yf3s7y1215jmikbs18cn4j8a13csp4763w3jfgah8zlim6vc47";
    };
  };

  en_CA-large = en-ca-large;
  en-ca-large = mkDictFromWordlist {
    shortName = "en-ca-large";
    shortDescription = "English (Canada) Large";
    srcFileName = "en_CA-large";
    dictFileName = "en_CA";
    src = fetchurl {
      url = mirror://sourceforge/wordlist/speller/2018.04.16/hunspell-en_CA-large-2018.04.16.zip;
      sha256 = "1200xxyvv6ni8nk52v3059c367817vnrkm0cdh38rhiigb5flfha";
    };
  };

  en_AU = en-au;
  en-au = mkDictFromWordlist {
    shortName = "en-au";
    shortDescription = "English (Australia)";
    srcFileName = "en_AU";
    dictFileName = "en_AU";
    src = fetchurl {
      url = mirror://sourceforge/wordlist/speller/2018.04.16/hunspell-en_AU-2018.04.16.zip;
      sha256 = "1kp06npl1kd05mm9r52cg2iwc13x02zwqgpibdw15b6x43agg6f5";
    };
  };

  en_AU-large = en-au-large;
  en-au-large = mkDictFromWordlist {
    shortName = "en-au-large";
    shortDescription = "English (Australia) Large";
    srcFileName = "en_AU-large";
    dictFileName = "en_AU";
    src = fetchurl {
      url = mirror://sourceforge/wordlist/speller/2018.04.16/hunspell-en_AU-large-2018.04.16.zip;
      sha256 = "14l1w4dpk0k1js2wwq5ilfil89ni8cigph95n1rh6xi4lzxj7h6g";
    };
  };

  en_GB-ise = en-gb-ise;
  en-gb-ise = mkDictFromWordlist {
    shortName = "en-gb-ise";
    shortDescription = "English (United Kingdom, 'ise' ending)";
    srcFileName = "en_GB-ise";
    dictFileName = "en_GB";
    src = fetchurl {
      url = mirror://sourceforge/wordlist/speller/2018.04.16/hunspell-en_GB-ise-2018.04.16.zip;
      sha256 = "0ylg1zvfvsawamymcc9ivrqcb9qhlpgpnizm076xc56jz554xc2l";
    };
  };

  en_GB-ize = en-gb-ize;
  en-gb-ize = mkDictFromWordlist {
    shortName = "en-gb-ize";
    shortDescription = "English (United Kingdom, 'ize' ending)";
    srcFileName = "en_GB-ize";
    dictFileName = "en_GB";
    src = fetchurl {
      url = mirror://sourceforge/wordlist/speller/2018.04.16/hunspell-en_GB-ize-2018.04.16.zip;
      sha256 = "1rmwy6sxmd400cwjf58az6g14sq28p18f5mlq8ybg8y33q9m42ps";
    };
  };

  en_GB-large = en-gb-large;
  en-gb-large = mkDictFromWordlist {
    shortName = "en-gb-large";
    shortDescription = "English (United Kingdom) Large";
    srcFileName = "en_GB-large";
    dictFileName = "en_GB";
    src = fetchurl {
      url = mirror://sourceforge/wordlist/speller/2018.04.16/hunspell-en_GB-large-2018.04.16.zip;
      sha256 = "1y4d7x5vvi1qh1s3i09m0vvqrpdzzqhsdngr8nsh7hc5bnlm37mi";
    };
  };

  /* SPANISH */

  es_ANY = es-any;
  es-any = mkDictFromRla {
    shortName = "es-any";
    shortDescription = "Spanish (any variant)";
    dictFileName = "es_ANY";
  };

  es_AR = es-ar;
  es-ar = mkDictFromRla {
    shortName = "es-ar";
    shortDescription = "Spanish (Argentina)";
    dictFileName = "es_AR";
  };

  es_BO = es-bo;
  es-bo = mkDictFromRla {
    shortName = "es-bo";
    shortDescription = "Spanish (Bolivia)";
    dictFileName = "es_BO";
  };

  es_CL = es-cl;
  es-cl = mkDictFromRla {
    shortName = "es-cl";
    shortDescription = "Spanish (Chile)";
    dictFileName = "es_CL";
  };

  es_CO = es-co;
  es-co = mkDictFromRla {
    shortName = "es-co";
    shortDescription = "Spanish (Colombia)";
    dictFileName = "es_CO";
  };

  es_CR = es-cr;
  es-cr = mkDictFromRla {
    shortName = "es-cr";
    shortDescription = "Spanish (Costra Rica)";
    dictFileName = "es_CR";
  };

  es_CU = es-cu;
  es-cu = mkDictFromRla {
    shortName = "es-cu";
    shortDescription = "Spanish (Cuba)";
    dictFileName = "es_CU";
  };

  es_DO = es-do;
  es-do = mkDictFromRla {
    shortName = "es-do";
    shortDescription = "Spanish (Dominican Republic)";
    dictFileName = "es_DO";
  };

  es_EC = es-ec;
  es-ec = mkDictFromRla {
    shortName = "es-ec";
    shortDescription = "Spanish (Ecuador)";
    dictFileName = "es_EC";
  };

  es_ES = es-es;
  es-es = mkDictFromRla {
    shortName = "es-es";
    shortDescription = "Spanish (Spain)";
    dictFileName = "es_ES";
  };

  es_GT = es-gt;
  es-gt = mkDictFromRla {
    shortName = "es-gt";
    shortDescription = "Spanish (Guatemala)";
    dictFileName = "es_GT";
  };

  es_HN = es-hn;
  es-hn = mkDictFromRla {
    shortName = "es-hn";
    shortDescription = "Spanish (Honduras)";
    dictFileName = "es_HN";
  };

  es_MX = es-mx;
  es-mx = mkDictFromRla {
    shortName = "es-mx";
    shortDescription = "Spanish (Mexico)";
    dictFileName = "es_MX";
  };

  es_NI = es-ni;
  es-ni = mkDictFromRla {
    shortName = "es-ni";
    shortDescription = "Spanish (Nicaragua)";
    dictFileName = "es_NI";
  };

  es_PA = es-pa;
  es-pa = mkDictFromRla {
    shortName = "es-pa";
    shortDescription = "Spanish (Panama)";
    dictFileName = "es_PA";
  };

  es_PE = es-pe;
  es-pe = mkDictFromRla {
    shortName = "es-pe";
    shortDescription = "Spanish (Peru)";
    dictFileName = "es_PE";
  };

  es_PR = es-pr;
  es-pr = mkDictFromRla {
    shortName = "es-pr";
    shortDescription = "Spanish (Puerto Rico)";
    dictFileName = "es_PR";
  };

  es_PY = es-py;
  es-py = mkDictFromRla {
    shortName = "es-py";
    shortDescription = "Spanish (Paraguay)";
    dictFileName = "es_PY";
  };

  es_SV = es-sv;
  es-sv = mkDictFromRla {
    shortName = "es-sv";
    shortDescription = "Spanish (El Salvador)";
    dictFileName = "es_SV";
  };

  es_UY = es-uy;
  es-uy = mkDictFromRla {
    shortName = "es-uy";
    shortDescription = "Spanish (Uruguay)";
    dictFileName = "es_UY";
  };

  es_VE = es-ve;
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
    isDefault = true;
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

  it_IT = it-it;
  it-it =  mkDictFromLinguistico {
    shortName = "it-it";
    dictFileName = "it_IT";
    shortDescription = "Hunspell dictionary for 'Italian (Italy)' from Linguistico";
    src = fetchurl {
      url = mirror://sourceforge/linguistico/italiano_2_4_2007_09_01.zip;
      sha256 = "0m9frz75fx456bczknay5i446gdcp1smm48lc0qfwzhz0j3zcdrd";
    };
  };

  /* BASQUE */

  eu_ES = eu-es;
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

  hu_HU = hu-hu;
  hu-hu = mkDictFromLibreOffice {
    shortName = "hu-hu";
    dictFileName = "hu_HU";
    shortDescription = "Hungarian (Hungary)";
    license = with stdenv.lib.licenses; [ mpl20 lgpl3 ];
  };

  /* SWEDISH */

  sv_SE = sv-se;
  sv-se = mkDictFromDSSO {
    shortName = "sv-se";
    dictFileName = "sv_SE";
    shortDescription = "Swedish (Sweden)";
  };

  # Finlandian Swedish (hello Linus Torvalds)
  sv_FI = sv-fi;
  sv-fi = mkDictFromDSSO {
    shortName = "sv-fi";
    dictFileName = "sv_FI";
    shortDescription = "Swedish (Finland)";
  };

  /* GERMAN */

  de_DE = de-de;
  de-de = mkDictFromJ3e {
    shortName = "de-de";
    shortDescription = "German (Germany)";
    dictFileName = "de_DE";
  };

  de_AT = de-at;
  de-at = mkDictFromJ3e {
    shortName = "de-at";
    shortDescription = "German (Austria)";
    dictFileName = "de_AT";
  };

  de_CH = de-ch;
  de-ch = mkDictFromJ3e {
    shortName = "de-ch";
    shortDescription = "German (Switzerland)";
    dictFileName = "de_CH";
  };

  /* UKRAINIAN */

  uk_UA = uk-ua;
  uk-ua = mkDict rec {
    name = "hunspell-dict-uk-ua-${version}";
    version = "4.6.3";
    _version = "4-6.3";

    src = fetchurl {
      url = "https://extensions.libreoffice.org/extensions/ukrainian-spelling-dictionary-and-thesaurus/${_version}/@@download/file/dict-uk_UA-${version}.oxt";
      sha256 = "14rd07yx4fx2qxjr5xqc8qy151idd8k2hr5yi18d9r8gccnm9w50";
    };

    dictFileName = "uk_UA";
    readmeFile = "README_uk_UA.txt";
    nativeBuildInputs = [ unzip ];
    unpackCmd = ''
      unzip $src ${dictFileName}/{${dictFileName}.dic,${dictFileName}.aff,${readmeFile}}
    '';

    meta = with stdenv.lib; {
      description = "Hunspell dictionary for Ukrainian (Ukraine) from LibreOffice";
      homepage = https://extensions.libreoffice.org/extensions/ukrainian-spelling-dictionary-and-thesaurus/;
      license = licenses.mpl20;
      maintainers = with maintainers; [ dywedir ];
      platforms = platforms.all;
    };
  };

  /* RUSSIAN */

  ru_RU = ru-ru;
  ru-ru = mkDictFromLibreOffice {
    shortName = "ru-ru";
    dictFileName = "ru_RU";
    shortDescription = "Russian (Russian)";
    license = with stdenv.lib.licenses; [ mpl20 lgpl3 ];
  };

  /* CZECH */

  cs_CZ = cs-cz;
  cs-cz = mkDictFromLibreOffice {
    shortName = "cs-cz";
    dictFileName = "cs_CZ";
    shortDescription = "Czech (Czechia)";
    readmeFile = "README_cs.txt";
    license = with stdenv.lib.licenses; [ gpl2 ];
  };

  /* SLOVAK */

  sk_SK = sk-sk;
  sk-sk = mkDictFromLibreOffice {
    shortName = "sk-sk";
    dictFileName = "sk_SK";
    shortDescription = "Slovak (Slovakia)";
    readmeFile = "README_sk.txt";
    license = with stdenv.lib.licenses; [ gpl2 lgpl21 mpl11 ];
  };
}
