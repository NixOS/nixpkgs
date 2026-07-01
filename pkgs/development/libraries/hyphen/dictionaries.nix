# hyphen dictionaries

{
  hyphen,
  stdenv,
  lib,
  fetchgit,
  symlinkJoin,
}:

let
  # this does not assume any structure for dictFilePath and readmeFilePath
  mkDictFromLibreofficeGitCustom =
    {
      subdir,
      shortName,
      dictFileName,
      shortDescription,
      dictFilePath,
      filenameAliases ? "",
      readmeFilePath ? "",
    }:
    stdenv.mkDerivation rec {
      version = "24.8";
      pname = "hyphen-dict-${shortName}-libreoffice";
      src = fetchgit {
        url = "https://anongit.freedesktop.org/git/libreoffice/dictionaries.git";
        rev = "e4ad1862342d7e1365978499ca951ae4788c9dc0";
        hash = "sha256-sv3KnmrewE1dRxeO+TqfOjfHjoJpzJ6p8MdBDiT3Ips=";
      };
      meta = {
        description = "Hyphen dictionary for ${shortDescription} from LibreOffice";
        homepage = "https://wiki.documentfoundation.org/Development/Dictionaries";
        license = with lib.licenses; [ mpl20 ];
        maintainers = with lib.maintainers; [ theCapypara ];
        platforms = lib.platforms.all;
      };
      dontBuild = true;
      installPhase = ''
        runHook preInstall
        cd $src/${subdir}
        install -dm755 "$out/share/hyphen"
        install -m644 "${dictFilePath}" "$out/share/hyphen"
        # Aliases can be found in dictionaries.xcu.
        for lang in ${filenameAliases}; do
          ln -s "$out/share/hyphen/hyph_${dictFileName}.dic" "$out/share/hyphen/hyph_$lang.dic"
        done
        # docs
        if [ -n "${readmeFilePath}" ]; then
          install -dm755 "$out/share/doc/"
          install -m644 "${readmeFilePath}" "$out/share/doc/${pname}.txt"
        fi
        runHook postInstall
      '';
    };

  # wrapper for backwards compatibility
  mkDictFromLibreofficeGit =
    {
      subdir,
      shortName,
      shortDescription,
      dictFileName,
      filenameAliases ? "",
      readmeFileName ? "",
    }:
    mkDictFromLibreofficeGitCustom {
      inherit subdir;
      inherit shortName;
      inherit shortDescription;
      dictFilePath = "hyph_${dictFileName}.dic";
      dictFileName = dictFileName;
      filenameAliases = filenameAliases;
      readmeFilePath = if (readmeFileName != "") then "README_${readmeFileName}.txt" else "";
    };

  dicts = rec {

    # see https://wiki.documentfoundation.org/Development/Dictionaries
    # for a list of available hyphenation dictionaries

    # see https://github.com/LibreOffice/dictionaries
    # for the sources and to find the names of the README files

    # AFRIKAANS

    af_NA = af-za;
    af_ZA = af-za;
    af-za = mkDictFromLibreofficeGit {
      subdir = "af_ZA";
      shortName = "af-za";
      shortDescription = "Afrikaans";
      dictFileName = "af_ZA";
      filenameAliases = "af_NA";
      readmeFileName = "af_ZA";
    };

    # ASSAMESE

    as_IN = as-in;
    as-in = mkDictFromLibreofficeGit {
      subdir = "as_IN";
      shortName = "as-in";
      shortDescription = "Assamese";
      dictFileName = "as_IN";
      readmeFileName = "as_IN";
    };

    # BELARUSSIAN

    be_BY = be-by;
    be-by = mkDictFromLibreofficeGit {
      subdir = "be_BY";
      shortName = "be-by";
      shortDescription = "Belarussian";
      dictFileName = "be_BY";
      readmeFileName = "be_BY";
    };

    # BULGARIAN

    bg_BG = bg-bg;
    bg-bg = mkDictFromLibreofficeGit {
      subdir = "bg_BG";
      shortName = "bg-bg";
      shortDescription = "Bulgarian";
      dictFileName = "bg_BG";
      readmeFileName = "hyph_bg_BG";
    };

    # CATALAN

    ca_ES_valencia = ca-es;
    ca_AD = ca-es;
    ca_FR = ca-es;
    ca_IT = ca-es;
    ca_ES = ca-es;
    ca-es = mkDictFromLibreofficeGitCustom {
      subdir = "ca";
      shortName = "ca-es";
      shortDescription = "Catalan";
      dictFileName = "ca";
      filenameAliases = "ca_ES_valencia ca_AD ca_FR ca_IT";
      dictFilePath = "dictionaries/hyph_ca.dic";
      readmeFilePath = "README_hyph_ca.txt";
    };

    # CZECH

    cs_CZ = cs-cz;
    cs-cz = mkDictFromLibreofficeGit {
      subdir = "cs_CZ";
      shortName = "cs-cz";
      shortDescription = "Czech";
      dictFileName = "cs_CZ";
      readmeFileName = "cs";
    };

    # DANISH

    da_DK = da-dk;
    da-dk = mkDictFromLibreofficeGitCustom {
      subdir = "da_DK";
      shortName = "da-dk";
      shortDescription = "Danish";
      dictFileName = "da_DK";
      dictFilePath = "hyph_da_DK.dic";
      readmeFilePath = "HYPH_da_DK_README.txt";
    };

    # GERMAN

    de_DE = de-de;
    de-de = mkDictFromLibreofficeGit {
      subdir = "de";
      shortName = "de-de";
      shortDescription = "German (Germany)";
      dictFileName = "de_DE";
      readmeFileName = "hyph_de";
    };

    de_AT = de-at;
    de-at = mkDictFromLibreofficeGit {
      subdir = "de";
      shortName = "de-at";
      shortDescription = "German (Austria)";
      dictFileName = "de_AT";
      readmeFileName = "hyph_de";
    };

    de_CH = de-ch;
    de-ch = mkDictFromLibreofficeGit {
      subdir = "de";
      shortName = "de-ch";
      shortDescription = "German (Switzerland)";
      dictFileName = "de_CH";
      readmeFileName = "hyph_de";
    };

    # GREEK

    el_GR = el-gr;
    el-gr = mkDictFromLibreofficeGit {
      subdir = "el_GR";
      shortName = "el-gr";
      shortDescription = "Greek";
      dictFileName = "el_GR";
      readmeFileName = "hyph_el_GR";
    };

    # ENGLISH

    en_GB = en-gb;
    en_ZA = en-gb;
    en_NA = en-gb;
    en_ZW = en-gb;
    en_AU = en-gb;
    en_CA = en-gb;
    en_IE = en-gb;
    en_IN = en-gb;
    en_BZ = en-gb;
    en_BS = en-gb;
    en_GH = en-gb;
    en_JM = en-gb;
    en_MW = en-gb;
    en_NZ = en-gb;
    en_TT = en-gb;
    en-gb = mkDictFromLibreofficeGit {
      subdir = "en";
      shortName = "en-gb";
      shortDescription = "English (Great Britain)";
      dictFileName = "en_GB";
      filenameAliases = "en_ZA en_NA en_ZW en_AU en_CA en_IE en_IN en_BZ en_BS en_GH en_JM en_MW en_NZ en_TT";
      readmeFileName = "hyph_en_GB";
    };

    en_US = en-us;
    en-us = stdenv.mkDerivation {
      nativeBuildInputs = hyphen.nativeBuildInputs;
      version = hyphen.version;
      pname = "hyphen-dict-en-us";
      src = hyphen.src;
      meta = {
        inherit (hyphen.meta)
          homepage
          platforms
          license
          maintainers
          ;
        description = "Hyphen dictionary for English (United States)";
      };
      installPhase = ''
        runHook preInstall
        make install-hyphDATA
        runHook postInstall
      '';
    };

    # ESPERANTO

    eo = mkDictFromLibreofficeGitCustom {
      subdir = "eo";
      shortName = "eo";
      shortDescription = "Esperanto";
      dictFileName = "eo";
      dictFilePath = "hyph_eo.dic";
      readmeFilePath = "desc_eo.txt";
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
    es_ES = es-es;
    es-es = mkDictFromLibreofficeGit {
      subdir = "es";
      shortName = "es-es";
      shortDescription = "Spanish";
      dictFileName = "es";
      filenameAliases = "es_AR es_BO es_CL es_CO es_CR es_CU es_DO es_EC es_GQ es_GT es_HN es_MX es_NI es_PA es_PE es_PH es_PR es_PY es_SV es_US es_UY es_VE";
      readmeFileName = "hyph_es";
    };

    # ESTONIAN

    et_EE = et-ee;
    et-ee = mkDictFromLibreofficeGit {
      subdir = "et_EE";
      shortName = "et-ee";
      shortDescription = "Estonian";
      dictFileName = "et_EE";
      readmeFileName = "hyph_et_EE";
    };

    # FRENCH

    fr_BE = fr-fr;
    fr_CA = fr-fr;
    fr_CH = fr-fr;
    fr_LU = fr-fr;
    fr_MC = fr-fr;
    fr_FR = fr-fr;
    fr-fr = mkDictFromLibreofficeGit {
      subdir = "fr_FR";
      shortName = "fr-fr";
      shortDescription = "French";
      dictFileName = "fr";
      filenameAliases = "fr_BE fr_CA fr_CH fr_LU fr_MC";
      readmeFileName = "hyph_fr";
    };

    # GALICIAN

    gl_ES = gl-es;
    gl-es = mkDictFromLibreofficeGit {
      subdir = "gl";
      shortName = "gl-es";
      shortDescription = "Galician";
      dictFileName = "gl";
      readmeFileName = "hyph-gl";
    };

    # CROATIAN

    hr_HR = hr-hr;
    hr-hr = mkDictFromLibreofficeGit {
      subdir = "hr_HR";
      shortName = "hr-hr";
      shortDescription = "Croatian";
      dictFileName = "hr_HR";
      readmeFileName = "hyph_hr_HR";
    };

    # HUNGARIAN

    hu_HU = hu-hu;
    hu-hu = mkDictFromLibreofficeGit {
      subdir = "hu_HU";
      shortName = "hu-hu";
      shortDescription = "Hungarian";
      dictFileName = "hu_HU";
      readmeFileName = "hyph_hu_HU";
    };

    # INDONESIAN

    id_ID = id-id;
    id-id = mkDictFromLibreofficeGitCustom {
      subdir = "id";
      shortName = "id-id";
      shortDescription = "Indonesian";
      dictFileName = "id_ID";
      dictFilePath = "hyph_id_ID.dic";
      readmeFilePath = "README-dict.adoc";
    };

    # ITALIAN

    it-CH = it-it;
    it_IT = it-it;
    it-it = mkDictFromLibreofficeGit {
      subdir = "it_IT";
      shortName = "it-it";
      shortDescription = "Italian";
      dictFileName = "it_IT";
      filenameAliases = "it_CH";
      readmeFileName = "hyph_it_IT";
    };

    # KANNADA

    kn_IN = kn-in;
    kn-in = mkDictFromLibreofficeGitCustom {
      subdir = "kn_IN";
      shortName = "kn-in";
      shortDescription = "Kannada";
      dictFileName = "kn_IN";
      dictFilePath = "hyph_kn_IN.dic";
      readmeFilePath = "README-kn_IN.txt";
    };

    # LITHUANIAN

    lt_LT = lt-lt;
    lt-lt = mkDictFromLibreofficeGitCustom {
      subdir = "lt_LT";
      shortName = "lt-lt";
      shortDescription = "Lithuanian";
      dictFileName = "lt";
      dictFilePath = "hyph_lt.dic";
      readmeFilePath = "README_hyph";
    };

    # LATVIAN

    lv_LV = lv-lv;
    lv-lv = mkDictFromLibreofficeGit {
      subdir = "lv_LV";
      shortName = "lv-lv";
      shortDescription = "Latvian";
      dictFileName = "lv_LV";
      readmeFileName = "hyph_lv_LV";
    };

    # MONGOLIAN

    mn_MN = mn-mn;
    mn-mn = mkDictFromLibreofficeGit {
      subdir = "mn_MN";
      shortName = "mn-mn";
      shortDescription = "Mongolian";
      dictFileName = "mn_MN";
      readmeFileName = "mn_MN";
    };

    # DUTCH

    nl_BE = nl-nl;
    nl_NL = nl-nl;
    nl-nl = mkDictFromLibreofficeGit {
      subdir = "nl_NL";
      shortName = "nl-nl";
      shortDescription = "Dutch";
      dictFileName = "nl_NL";
      filenameAliases = "nl_BE";
      readmeFileName = "NL";
    };

    # NORWEGIAN

    nb_NO = nb-no;
    nb-no = mkDictFromLibreofficeGit {
      subdir = "no";
      shortName = "nb-no";
      shortDescription = "Norwegian (Bokmål)";
      dictFileName = "nb_NO";
      readmeFileName = "hyph_NO";
    };

    nn_NO = nn-no;
    nn-no = mkDictFromLibreofficeGit {
      subdir = "no";
      shortName = "nn-no";
      shortDescription = "Norwegian (Nynorsk)";
      dictFileName = "nn_NO";
      readmeFileName = "hyph_NO";
    };

    # ORIYA

    or_IN = or-in;
    or-in = mkDictFromLibreofficeGit {
      subdir = "or_IN";
      shortName = "or-in";
      shortDescription = "Oriya";
      dictFileName = "or_IN";
    };

    # PANJABI

    pa_IN = pa-in;
    pa-in = mkDictFromLibreofficeGit {
      subdir = "pa_IN";
      shortName = "pa-in";
      shortDescription = "Panjabi";
      dictFileName = "pa_IN";
    };

    # POLISH

    pl_PL = pl-pl;
    pl-pl = mkDictFromLibreofficeGit {
      subdir = "pl_PL";
      shortName = "pl-pl";
      shortDescription = "Polish";
      dictFileName = "pl_PL";
      readmeFileName = "pl";
    };

    # PORTUGUESE

    pt_BR = pt-br;
    pt-br = mkDictFromLibreofficeGit {
      subdir = "pt_BR";
      shortName = "pt-br";
      shortDescription = "Portuguese (Brazil)";
      dictFileName = "pt_BR";
      readmeFileName = "hyph_pt_BR";
    };

    pt_PT = pt-pt;
    pt-pt = mkDictFromLibreofficeGit {
      subdir = "pt_PT";
      shortName = "pt-pt";
      shortDescription = "Portuguese (Portugal)";
      dictFileName = "pt_PT";
      readmeFileName = "hyph_pt_PT";
    };

    # ROMANIAN

    ro_RO = ro-ro;
    ro-ro = mkDictFromLibreofficeGit {
      subdir = "ro";
      shortName = "ro-ro";
      shortDescription = "Romanian";
      dictFileName = "ro_RO";
      readmeFileName = "RO";
    };

    # RUSSIAN

    ru_RU = ru-ru;
    ru-ru = mkDictFromLibreofficeGit {
      subdir = "ru_RU";
      shortName = "ru-ru";
      shortDescription = "Russian (Russia)";
      dictFileName = "ru_RU";
      readmeFileName = "ru_RU";
    };

    # SANSKRIT

    sa_IN = sa-in;
    sa-in = mkDictFromLibreofficeGit {
      subdir = "sa_IN";
      shortName = "sa-in";
      shortDescription = "Sanskrit (India)";
      dictFileName = "sa_IN";
    };

    # SLOVAK

    sk_SK = sk-sk;
    sk-sk = mkDictFromLibreofficeGit {
      subdir = "sk_SK";
      shortName = "sk-sk";
      shortDescription = "Slovak";
      dictFileName = "sk_SK";
      readmeFileName = "sk";
    };

    # SLOVENIAN

    sl_SI = sl-si;
    sl-si = mkDictFromLibreofficeGit {
      subdir = "sl_SI";
      shortName = "sl-si";
      shortDescription = "Slovenian";
      dictFileName = "sl_SI";
      readmeFileName = "hyph_sl_SI";
    };

    # ALBANIAN

    sq_AL = sq-al;
    sq-al = mkDictFromLibreofficeGit {
      subdir = "sq_AL";
      shortName = "sq-al";
      shortDescription = "Albanian";
      dictFileName = "sq_AL";
      readmeFileName = "hyph_sq_AL";
    };

    # SERBIAN

    sr_SR = sr-sr;
    sr-sr = mkDictFromLibreofficeGitCustom {
      subdir = "sr";
      shortName = "sr-sr";
      shortDescription = "Serbian (Cyrillic)";
      dictFileName = "sr";
      dictFilePath = "hyph_sr.dic";
      readmeFilePath = "README.txt";
    };

    sr_SR_LATN = sr-sr-latn;
    sr-sr-latn = mkDictFromLibreofficeGitCustom {
      subdir = "sr";
      shortName = "sr-sr-latn";
      shortDescription = "Serbian (Latin)";
      dictFileName = "sr-Latn";
      dictFilePath = "hyph_sr-Latn.dic";
      readmeFilePath = "README.txt";
    };

    # SWEDISH

    sv_FI = sv-se;
    sv_SE = sv-se;
    sv-se = mkDictFromLibreofficeGit {
      subdir = "sv_SE";
      shortName = "sv-se";
      shortDescription = "Swedish";
      dictFileName = "sv";
      readmeFileName = "hyph_sv";
    };

    # TELUGU

    te_IN = te-in;
    te-in = mkDictFromLibreofficeGit {
      subdir = "te_IN";
      shortName = "te-in";
      shortDescription = "Telugu";
      dictFileName = "te_IN";
      readmeFileName = "hyph_te_IN";
    };

    # THAI

    th_TH = th-th;
    th-th = mkDictFromLibreofficeGit {
      subdir = "th_TH";
      shortName = "th-th";
      shortDescription = "Thai";
      dictFileName = "th_TH";
      readmeFileName = "hyph_th_TH";
    };

    # UKRAINIAN

    uk_UA = uk-ua;
    uk-ua = mkDictFromLibreofficeGit {
      subdir = "uk_UA";
      shortName = "uk-ua";
      shortDescription = "Ukrainian";
      dictFileName = "uk_UA";
      readmeFileName = "hyph_uk_UA";
    };

    # ZULU

    zu_ZA = zu-za;
    zu-za = mkDictFromLibreofficeGitCustom {
      subdir = "zu_ZA";
      shortName = "zu-za";
      shortDescription = "Zulu";
      dictFileName = "zu_ZA";
      dictFilePath = "hyph_zu_ZA.dic";
      # no readme file provided, leave empty
    };

  };

in
dicts
// {
  all = symlinkJoin {
    name = "hyphen-all";
    paths = lib.unique (lib.attrValues dicts);
  };
}
