{ lib, stdenv, fetchgit }:

let
  mkDictFromChromium = { shortName, dictFileName, shortDescription }:
    stdenv.mkDerivation {
      pname = "hunspell-dict-${shortName}-chromium";
      version = "115.0.5790.170";

      src = fetchgit {
        url = "https://chromium.googlesource.com/chromium/deps/hunspell_dictionaries";
        rev = "41cdffd71c9948f63c7ad36e1fb0ff519aa7a37e";
        hash = "sha256-67mvpJRFFa9eMfyqFMURlbxOaTJBICnk+gl0b0mEHl8=";
      };

      dontBuild = true;

      installPhase = ''
        cp ${dictFileName} $out
      '';

      passthru = {
        # As chromium needs the exact filename in ~/.config/chromium/Dictionaries,
        # this value needs to be known to tools using the package if they want to
        # link the file correctly.
        inherit dictFileName;

        updateScript = ./update-chromium-dictionaries.py;
      };

      meta = {
        homepage = "https://chromium.googlesource.com/chromium/deps/hunspell_dictionaries/";
        description = "Chromium compatible hunspell dictionary for ${shortDescription}";
        longDescription = ''
          Humspell directories in Chromium's custom bdic format

          See https://www.chromium.org/developers/how-tos/editing-the-spell-checking-dictionaries/
        '';
        license = with lib.licenses; [ gpl2 lgpl21 mpl11 lgpl3 ];
        maintainers = with lib.maintainers; [ networkexception ];
        platforms = lib.platforms.all;
      };
    };
in
rec {

  /* ENGLISH */

  en_US = en-us;
  en-us = mkDictFromChromium {
    shortName = "en-us";
    dictFileName = "en-US-10-1.bdic";
    shortDescription = "English (United States)";
  };

  en_GB = en-us;
  en-gb = mkDictFromChromium {
    shortName = "en-gb";
    dictFileName = "en-GB-10-1.bdic";
    shortDescription = "English (United Kingdom)";
  };

  /* GERMAN */

  de_DE = de-de;
  de-de = mkDictFromChromium {
    shortName = "de-de";
    dictFileName = "de-DE-3-0.bdic";
    shortDescription = "German (Germany)";
  };

  /* FRENCH */

  fr_FR = fr-fr;
  fr-fr = mkDictFromChromium {
    shortName = "fr-fr";
    dictFileName = "fr-FR-3-0.bdic";
    shortDescription = "French (France)";
  };
}
