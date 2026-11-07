# hyphen dictionaries

{
  fetchgit,
  hyphen,
  lib,
  stdenv,
  symlinkJoin,
}:

let
  mkDictFromLibreOfficeGit =
    {
      dictFilename,
      shortName ? (lib.replaceString "_" "-" (lib.toLower dictFilename)),
      shortDescription ? dictFilename,
      dictAliases ? [ ],
    }:
    stdenv.mkDerivation rec {
      version = "26.2.7.3";
      pname = "hyphen-dict-${shortName}-libreoffice";
      __structuredAttrs = true;
      dontBuild = true;

      src = fetchgit {
        # Use the official repository.
        url = "https://git.libreoffice.org/dictionaries";
        tag = "libreoffice-${version}";
        hash = "sha256-mLnwfmc+kR1NcxTkc1PShmNTB4bTfiM0IgFR/W3ueiY=";
      };

      meta = {
        description = "Hyphenation dictionary for ${shortDescription} from LibreOffice";
        homepage = "https://wiki.documentfoundation.org/Development/Dictionaries";
        license = lib.licenses.mpl20;
        maintainers = with lib.maintainers; [
          theCapypara
          ekhh
        ];
        platforms = lib.platforms.all;
      };

      installPhase = ''
        runHook preInstall

        # Dictionary files relocate to unpredictable places with each release;
        # these simplify maintenance.
        declare DICT_FILE_PATH="$(find "$src" -name "hyph_${dictFilename}.dic" -print -quit 2>/dev/null)"
        declare README_FILE_PATH="$(find "$src" -name "README_hyph_${dictFilename}.txt" -print -quit 2>/dev/null)"

        install -Dm644 "$DICT_FILE_PATH" "$out/share/hyphen/$(basename "$DICT_FILE_PATH")"
        if [ -n "$README_FILE_PATH" ]; then
          # Use the same naming scheme as the original file to increase discoverability.
          install -Dm644 "$README_FILE_PATH" "$out/share/doc/hyphen/$(basename "$README_FILE_PATH")"
        fi
        for alias in ${lib.concatStringsSep " " dictAliases}; do
          ln -s "$out/share/hyphen/hyph_${dictFilename}.dic" "$out/share/hyphen/hyph_$alias.dic"
        done

        runHook postInstall
      '';
    };

  dicts = rec {
    # A list of hyphenation dictionaries is available at
    # <https://wiki.documentfoundation.org/Development/Dictionaries>
    # Language aliases can be found in `dictionaries.xcu` files under `Locales`
    # props in nodes with `HyphDic_` prefix. Note that each file may contain
    # more than one such node.

    # PLEASE KEEP THIS LIST IN ALPHABETICAL ORDER.

    # AFRIKAANS
    af_NA = af-za;
    af_ZA = af-za;
    af-za = mkDictFromLibreOfficeGit {
      shortDescription = "Afrikaans";
      dictFilename = "af_ZA";
      dictAliases = [ "af_NA" ];
    };

    # ALBANIAN
    sq_AL = sq-al;
    sq-al = mkDictFromLibreOfficeGit {
      shortDescription = "Albanian";
      dictFilename = "sq_AL";
    };

    # ASSAMESE
    as_IN = as-in;
    as-in = mkDictFromLibreOfficeGit {
      shortDescription = "Assamese";
      dictFilename = "as_IN";
    };

    # BELARUSSIAN
    be_BY = be-by;
    be-by = mkDictFromLibreOfficeGit {
      shortDescription = "Belarussian";
      dictFilename = "be_BY";
    };

    # BULGARIAN
    bg_BG = bg-bg;
    bg-bg = mkDictFromLibreOfficeGit {
      shortDescription = "Bulgarian";
      dictFilename = "bg_BG";
    };

    # CATALAN
    ca_AD = ca-es;
    ca_ES = ca-es;
    ca_ES_valencia = ca-es;
    ca_FR = ca-es;
    ca_IT = ca-es;
    ca-es = mkDictFromLibreOfficeGit {
      shortName = "ca-es";
      shortDescription = "Catalan";
      dictFilename = "ca";
      dictAliases = [
        "ca_AD"
        "ca_ES"
        "ca_ES_valencia"
        "ca_FR"
        "ca_IT"
      ];
    };

    # CROATIAN
    hr_HR = hr-hr;
    hr-hr = mkDictFromLibreOfficeGit {
      shortDescription = "Croatian";
      dictFilename = "hr_HR";
    };

    # CZECH
    cs_CZ = cs-cz;
    cs-cz = mkDictFromLibreOfficeGit {
      shortDescription = "Czech";
      dictFilename = "cs_CZ";
    };

    # DANISH
    da_DK = da-dk;
    da-dk = mkDictFromLibreOfficeGit {
      shortDescription = "Danish";
      dictFilename = "da_DK";
    };

    # DUTCH
    nl_BE = nl-nl;
    nl_NL = nl-nl;
    nl-nl = mkDictFromLibreOfficeGit {
      shortDescription = "Dutch";
      dictFilename = "nl_NL";
      dictAliases = [ "nl_BE" ];
    };

    # ENGLISH
    en_AU = en-gb;
    en_BS = en-gb;
    en_BZ = en-gb;
    en_CA = en-gb;
    en_GB = en-gb;
    en_GH = en-gb;
    en_IE = en-gb;
    en_IN = en-gb;
    en_JM = en-gb;
    en_MW = en-gb;
    en_NA = en-gb;
    en_NZ = en-gb;
    en_TT = en-gb;
    en_ZA = en-gb;
    en_ZW = en-gb;
    en-gb = mkDictFromLibreOfficeGit {
      shortDescription = "English (Great Britain)";
      dictFilename = "en_GB";
      dictAliases = [
        "en_AU"
        "en_BS"
        "en_BZ"
        "en_CA"
        "en_GH"
        "en_IE"
        "en_IN"
        "en_JM"
        "en_MW"
        "en_NA"
        "en_NZ"
        "en_TT"
        "en_ZA"
        "en_ZW"
      ];
    };
    en_US = en-us;
    en-us =
      stdenv.mkDerivation {
        nativeBuildInputs = hyphen.nativeBuildInputs;
        pname = "hyphen-dict-en-us";
        inherit (hyphen) src version meta;
        installPhase = ''
          runHook preInstall
          make install-hyphDATA
          runHook postInstall
        '';
      }
      // {
        meta.description = "Hyphen dictionary for English (United States)";
      };

    # ESPERANTO
    eo = mkDictFromLibreOfficeGit {
      shortDescription = "Esperanto";
      dictFilename = "eo";
    };

    # ESTONIAN
    et_EE = et-ee;
    et-ee = mkDictFromLibreOfficeGit {
      shortDescription = "Estonian";
      dictFilename = "et_EE";
    };

    # FRENCH
    fr_BE = fr-fr;
    fr_CA = fr-fr;
    fr_CH = fr-fr;
    fr_FR = fr-fr;
    fr_LU = fr-fr;
    fr_MC = fr-fr;
    fr-fr = mkDictFromLibreOfficeGit {
      shortName = "fr-fr";
      shortDescription = "French";
      dictAliases = [
        "fr_BE"
        "fr_CA"
        "fr_CH"
        "fr_FR"
        "fr_LU"
        "fr_MC"
      ];
      dictFilename = "fr";
    };

    # GALICIAN
    gl_ES = gl-es;
    gl-es = mkDictFromLibreOfficeGit {
      shortName = "gl-es";
      shortDescription = "Galician";
      dictFilename = "gl";
    };

    # GERMAN
    de_AT = de-at;
    de-at = mkDictFromLibreOfficeGit {
      shortDescription = "German (Austria)";
      dictFilename = "de_AT";
    };
    de_CH = de-ch;
    de-ch = mkDictFromLibreOfficeGit {
      shortDescription = "German (Switzerland)";
      dictFilename = "de_CH";
    };
    de_DE = de-de;
    de-de = mkDictFromLibreOfficeGit {
      shortDescription = "German (Germany)";
      dictFilename = "de_DE";
    };

    # GREEK
    el_GR = el-gr;
    el-gr = mkDictFromLibreOfficeGit {
      shortDescription = "Greek";
      dictFilename = "el_GR";
    };

    # HUNGARIAN
    hu_HU = hu-hu;
    hu-hu = mkDictFromLibreOfficeGit {
      shortDescription = "Hungarian";
      dictFilename = "hu_HU";
    };

    # ICELANDIC
    is_IS = is;
    is = mkDictFromLibreOfficeGit {
      shortDescription = "Icelandic";
      dictFilename = "is";
      dictAliases = [ "is_IS" ];
    };

    # INDONESIAN
    id_ID = id-id;
    id-id = mkDictFromLibreOfficeGit {
      shortDescription = "Indonesian";
      dictFilename = "id_ID";
    };

    # ITALIAN
    it-CH = it-it;
    it_IT = it-it;
    it-it = mkDictFromLibreOfficeGit {
      shortDescription = "Italian";
      dictFilename = "it_IT";
      dictAliases = [ "it_CH" ];
    };

    # KANNADA
    kn_IN = kn-in;
    kn-in = mkDictFromLibreOfficeGit {
      shortDescription = "Kannada";
      dictFilename = "kn_IN";
    };

    # LATVIAN
    lv_LV = lv-lv;
    lv-lv = mkDictFromLibreOfficeGit {
      shortDescription = "Latvian";
      dictFilename = "lv_LV";
    };

    # LITHUANIAN
    lt_LT = lt-lt;
    lt-lt = mkDictFromLibreOfficeGit {
      shortName = "lt-lt";
      shortDescription = "Lithuanian";
      dictFilename = "lt";
    };

    # MARATHI
    mr_IN = mr-in;
    mr-in = mkDictFromLibreOfficeGit {
      shortDescription = "Marathi";
      dictFilename = "mr_IN";
    };

    # MONGOLIAN
    mn_MN = mn-mn;
    mn-mn = mkDictFromLibreOfficeGit {
      shortDescription = "Mongolian";
      dictFilename = "mn_MN";
    };

    # NORWEGIAN
    nb_NO = nb-no;
    nb-no = mkDictFromLibreOfficeGit {
      shortDescription = "Norwegian (Bokmål)";
      dictFilename = "nb_NO";
    };
    nn_NO = nn-no;
    nn-no = mkDictFromLibreOfficeGit {
      shortDescription = "Norwegian (Nynorsk)";
      dictFilename = "nn_NO";
    };

    # ORIYA
    or_IN = or-in;
    or-in = mkDictFromLibreOfficeGit {
      shortDescription = "Oriya";
      dictFilename = "or_IN";
    };

    # PANJABI
    pa_IN = pa-in;
    pa-in = mkDictFromLibreOfficeGit {
      shortDescription = "Panjabi";
      dictFilename = "pa_IN";
    };

    # POLISH
    pl_PL = pl-pl;
    pl-pl = mkDictFromLibreOfficeGit {
      shortDescription = "Polish";
      dictFilename = "pl_PL";
    };

    # PORTUGUESE
    pt_BR = pt-br;
    pt-br = mkDictFromLibreOfficeGit {
      shortDescription = "Portuguese (Brazil)";
      dictFilename = "pt_BR";
    };
    pt_PT = pt-pt;
    pt-pt = mkDictFromLibreOfficeGit {
      shortDescription = "Portuguese (Portugal)";
      dictFilename = "pt_PT";
    };

    # ROMANIAN
    ro_RO = ro-ro;
    ro-ro = mkDictFromLibreOfficeGit {
      shortDescription = "Romanian";
      dictFilename = "ro_RO";
    };

    # RUSSIAN
    ru_RU = ru-ru;
    ru-ru = mkDictFromLibreOfficeGit {
      shortDescription = "Russian (Russia)";
      dictFilename = "ru_RU";
    };

    # SANSKRIT
    sa_IN = sa-in;
    sa-in = mkDictFromLibreOfficeGit {
      shortDescription = "Sanskrit (India)";
      dictFilename = "sa_IN";
    };

    # SERBIAN
    sr_SR = sr-sr;
    sr-sr = mkDictFromLibreOfficeGit {
      shortName = "sr-sr";
      shortDescription = "Serbian (Cyrillic)";
      dictFilename = "sr";
    };
    sr_SR_LATN = sr-sr-latn;
    sr-sr-latn = mkDictFromLibreOfficeGit {
      shortName = "sr-sr-latn";
      shortDescription = "Serbian (Latin)";
      dictFilename = "sr-Latn";
    };

    # SLOVAK
    sk_SK = sk-sk;
    sk-sk = mkDictFromLibreOfficeGit {
      shortDescription = "Slovak";
      dictFilename = "sk_SK";
    };

    # SLOVENIAN
    sl_SI = sl-si;
    sl-si = mkDictFromLibreOfficeGit {
      shortDescription = "Slovenian";
      dictFilename = "sl_SI";
    };

    # SPANISH
    es_AR = es-es;
    es_BO = es-es;
    es_CL = es-es;
    es_CO = es-es;
    es_CR = es-es;
    es_CU = es-es;
    es_DO = es-es;
    es_EC = es-es;
    es_ES = es-es;
    es_GQ = es-es;
    es_GT = es-es;
    es_HN = es-es;
    es_MX = es-es;
    es_NI = es-es;
    es_PA = es-es;
    es_PE = es-es;
    es_PH = es-es;
    es_PR = es-es;
    es_PY = es-es;
    es_SV = es-es;
    es_US = es-es;
    es_UY = es-es;
    es_VE = es-es;
    es-es = mkDictFromLibreOfficeGit {
      shortName = "es-es";
      shortDescription = "Spanish";
      dictFilename = "es";
      dictAliases = [
        "es_AR"
        "es_BO"
        "es_CL"
        "es_CO"
        "es_CR"
        "es_CU"
        "es_DO"
        "es_EC"
        "es_ES"
        "es_GQ"
        "es_GT"
        "es_HN"
        "es_MX"
        "es_NI"
        "es_PA"
        "es_PE"
        "es_PH"
        "es_PR"
        "es_PY"
        "es_SV"
        "es_US"
        "es_UY"
        "es_VE"
      ];
    };

    # SWEDISH
    sv_FI = sv-se;
    sv_SE = sv-se;
    sv-se = mkDictFromLibreOfficeGit {
      shortName = "sv-se";
      shortDescription = "Swedish";
      dictFilename = "sv";
    };

    # TELUGU
    te_IN = te-in;
    te-in = mkDictFromLibreOfficeGit {
      shortDescription = "Telugu";
      dictFilename = "te_IN";
    };

    # THAI
    th_TH = th-th;
    th-th = mkDictFromLibreOfficeGit {
      shortDescription = "Thai";
      dictFilename = "th_TH";
    };

    # UKRAINIAN
    uk_UA = uk-ua;
    uk-ua = mkDictFromLibreOfficeGit {
      shortDescription = "Ukrainian";
      dictFilename = "uk_UA";
    };

    # ZULU
    zu_ZA = zu-za;
    zu-za = mkDictFromLibreOfficeGit {
      shortDescription = "Zulu";
      dictFilename = "zu_ZA";
    };

    # PLEASE KEEP THIS LIST IN ALPHABETICAL ORDER.
  };

in
dicts
// {
  all = symlinkJoin {
    name = "hyphen-all";
    paths = lib.unique (lib.attrValues dicts);
  };
}
