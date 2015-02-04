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

  mkDictFromRedIRIS =
    { shortName, shortDescription, dictFileName, src }:
    mkDict rec {
      inherit src dictFileName;
      version = "0.7";
      name = "hunspell-dict-${shortName}-rediris-${version}";
      readmeFile = "README.txt";
      meta = with stdenv.lib; {
        description = "Hunspell dictionary for ${shortDescription} from RedIRIS";
        homepage = https://forja.rediris.es/projects/rla-es/;
        license = with licenses; [ gpl3 lgpl3 mpl11 ];
        maintainers = with maintainers; [ renzo ];
        platforms = platforms.all;
      };
    };

  mkDictFromDicollecte =
    { shortName, shortDescription, longDescription, dictFileName }:
    mkDict rec {
      inherit dictFileName;
      version = "5.2";
      name = "hunspell-dict-${shortName}-dicollecte-${version}";
      readmeFile = "README_dict_fr.txt";
      src = fetchurl {
         url = "http://www.dicollecte.org/download/fr/hunspell-french-dictionaries-v${version}.zip";
         sha256 = "c5863f7592a8c4defe8b4ed2b3b45f6f10ef265d34ae9881c1f3bbb3b80bdd02";
      };
      meta = with stdenv.lib; {
        inherit longDescription;
        description = "Hunspell dictionary for ${shortDescription} from Dicollecte";
        homepage = http://www.dicollecte.org/home.php?prj=fr;
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
        homepage =http://wordlist.aspell.net/;
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

  /* SPANISH */

  es-any = mkDictFromRedIRIS {
    shortName = "es-any";
    shortDescription = "Spanish (any variant)";
    dictFileName = "es_ANY";
    src = fetchurl {
      url = http://forja.rediris.es/frs/download.php/2933/es_ANY.oxt;
      md5 = "e3d4b38f280e7376178529db2ece982b";
    };
  };

  es-ar = mkDictFromRedIRIS {
    shortName = "es-ar";
    shortDescription = "Spanish (Argentina)";
    dictFileName = "es_AR";
    src = fetchurl {
      url = http://forja.rediris.es/frs/download.php/2953/es_AR.oxt;
      md5 = "68ee8f4ebc89a1fa461045d4dbb9b7be";
    };
  };

  es-bo = mkDictFromRedIRIS {
    shortName = "es-bo";
    shortDescription = "Spanish (Bolivia)";
    dictFileName = "es_BO";
    src = fetchurl {
      url = http://forja.rediris.es/frs/download.php/2952/es_BO.oxt;
      md5 = "1ebf11b6094e0bfece8e95cc34e7a409";
    };
  };

  es-cl = mkDictFromRedIRIS {
    shortName = "es-cl";
    shortDescription = "Spanish (Chile)";
    dictFileName = "es_CL";
    src = fetchurl {
      url = http://forja.rediris.es/frs/download.php/2951/es_CL.oxt;
      md5 = "092a388101350b77af4fd789668582bd";
    };
  };

  es-co = mkDictFromRedIRIS {
    shortName = "es-co";
    shortDescription = "Spanish (Colombia)";
    dictFileName = "es_CO";
    src = fetchurl {
      url = http://forja.rediris.es/frs/download.php/2950/es_CO.oxt;
      md5 = "fc440fd9fc55ca2dfb9bfa34a1e63864";
    };
  };

  es-cr = mkDictFromRedIRIS {
    shortName = "es-cr";
    shortDescription = "Spanish (Costra Rica)";
    dictFileName = "es_CR";
    src = fetchurl {
      url = http://forja.rediris.es/frs/download.php/2949/es_CR.oxt;
      md5 = "7510fd0f4eb3c6e65523a8d0960f77dd";
    };
  };

  es-cu = mkDictFromRedIRIS {
    shortName = "es-cu";
    shortDescription = "Spanish (Cuba)";
    dictFileName = "es_CU";
    src = fetchurl {
      url = http://forja.rediris.es/frs/download.php/2948/es_CU.oxt;
      md5 = "0ab4b9638f58ddd3d95d1265918ff39e";
    };
  };

  es-do = mkDictFromRedIRIS {
    shortName = "es-do";
    shortDescription = "Spanish (Dominican Republic)";
    dictFileName = "es_DO";
    src = fetchurl {
      url = http://forja.rediris.es/frs/download.php/2947/es_DO.oxt;
      md5 = "24a20fd4d887693afef539e6f1a3b58e";
    };
  };

  es-ec = mkDictFromRedIRIS {
    shortName = "es-ec";
    shortDescription = "Spanish (Ecuador)";
    dictFileName = "es_EC";
    src = fetchurl {
      url = http://forja.rediris.es/frs/download.php/2946/es_EC.oxt;
      md5 = "5d7343a246323ceda58cfbbf1428e279";
    };
  };

  es-es = mkDictFromRedIRIS {
    shortName = "es-es";
    shortDescription = "Spanish (Spain)";
    dictFileName = "es_ES";
    src = fetchurl {
      url = http://forja.rediris.es/frs/download.php/2945/es_ES.oxt;
      md5 = "59dd45e6785ed644adbbd73f4f126182";
    };
  };

  es-gt = mkDictFromRedIRIS {
    shortName = "es-gt";
    shortDescription = "Spanish (Guatemala)";
    dictFileName = "es_GT";
    src = fetchurl {
      url = http://forja.rediris.es/frs/download.php/2944/es_GT.oxt;
      md5 = "b1a9be80687e3117c67ac46aad6b8d66";
    };
  };

  es-hn = mkDictFromRedIRIS {
    shortName = "es-hn";
    shortDescription = "Spanish (Honduras)";
    dictFileName = "es_HN";
    src = fetchurl {
      url = http://forja.rediris.es/frs/download.php/2943/es_HN.oxt;
      md5 = "d0db5bebd6925738b524de9709950f22";
    };
  };

  es-mx = mkDictFromRedIRIS {
    shortName = "es-mx";
    shortDescription = "Spanish (Mexico)";
    dictFileName = "es_MX";
    src = fetchurl {
      url = http://forja.rediris.es/frs/download.php/2942/es_MX.oxt;
      md5 = "0de780714f84955112f38f35fb63a894";
    };
  };

  es-ni = mkDictFromRedIRIS {
    shortName = "es-ni";
    shortDescription = "Spanish (Nicaragua)";
    dictFileName = "es_NI";
    src = fetchurl {
      url = http://forja.rediris.es/frs/download.php/2941/es_NI.oxt;
      md5 = "d259d7be17c34df76c7de40c80720a39";
    };
  };

  es-pa = mkDictFromRedIRIS {
    shortName = "es-pa";
    shortDescription = "Spanish (Panama)";
    dictFileName = "es_PA";
    src = fetchurl {
      url = http://forja.rediris.es/frs/download.php/2940/es_PA.oxt;
      md5 = "085fbdbed6a2e248630c801881563b7a";
    };
  };

  es-pe = mkDictFromRedIRIS {
    shortName = "es-pe";
    shortDescription = "Spanish (Peru)";
    dictFileName = "es_PE";
    src = fetchurl {
      url = http://forja.rediris.es/frs/download.php/2939/es_PE.oxt;
      md5 = "f4673063246888995d4eaa2d4a24ee3d";
    };
  };

  es-pr = mkDictFromRedIRIS {
    shortName = "es-pr";
    shortDescription = "Spanish (Puerto Rico)";
    dictFileName = "es_PR";
    src = fetchurl {
      url = http://forja.rediris.es/frs/download.php/2938/es_PR.oxt;
      md5 = "e67bcf891ba9eeaeb57a60ec8e57f1ac";
    };
  };

  es-py = mkDictFromRedIRIS {
    shortName = "es-py";
    shortDescription = "Spanish (Paraguay)";
    dictFileName = "es_PY";
    src = fetchurl {
      url = http://forja.rediris.es/frs/download.php/2937/es_PY.oxt;
      md5 = "ba98e3197c81db4c572def2c5cca942d";
    };
  };

  es-sv = mkDictFromRedIRIS {
    shortName = "es-sv";
    shortDescription = "Spanish (El Salvador)";
    dictFileName = "es_SV";
    src = fetchurl {
      url = http://forja.rediris.es/frs/download.php/2936/es_SV.oxt;
      md5 = "c68ca9d188cb23c88cdd34a069c5a013";
    };
  };

  es-uy = mkDictFromRedIRIS {
    shortName = "es-uy";
    shortDescription = "Spanish (Uruguay)";
    dictFileName = "es_UY";
    src = fetchurl {
      url = http://forja.rediris.es/frs/download.php/2935/es_UY.oxt;
      md5 = "aeb9d39e4d17e9c904c1f3567178aad6";
    };
  };

  es-ve = mkDictFromRedIRIS {
    shortName = "es-ve";
    shortDescription = "Spanish (Venezuela)";
    dictFileName = "es_VE";
    src = fetchurl {
      url = http://forja.rediris.es/frs/download.php/2934/es_VE.oxt;
      md5 = "8afa9619aede2d9708e799e0f5d0fcab";
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
      md5 = "e7fbd9e2dfb25ea3288cdb918e1e1260";
    };
  };
}
