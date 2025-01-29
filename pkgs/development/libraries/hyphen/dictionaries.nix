# hyphen dictionaries

{
  hyphen,
  stdenv,
  lib,
  fetchgit,
  fetchurl,
}:

let
  libreofficeRepository = "https://anongit.freedesktop.org/git/libreoffice/dictionaries.git";
  libreofficeCommit = "9e27d044d98e65f89af8c86df722a77be827bdc8";
  libreofficeSubdir = "de";

  mkDictFromLibreofficeGit =
    {
      subdir,
      shortName,
      shortDescription,
      dictFileName,
      readmeFileName,
    }:
    stdenv.mkDerivation rec {
      version = "24.8";
      pname = "hyphen-dict-${shortName}-libreoffice";
      src = fetchgit {
        url = "https://anongit.freedesktop.org/git/libreoffice/dictionaries.git";
        rev = "a2bf59878dd76685803ec260e15d875746ad6e25";
        hash = "sha256-3CvjgNjsrm4obATK6LmtYob8i2ngTbwP6FB4HlJMPCE=";
      };
      meta = with lib; {
        description = "Hyphen dictionary for ${shortDescription} from LibreOffice";
        homepage = "https://wiki.documentfoundation.org/Development/Dictionaries";
        license = with licenses; [ mpl20 ];
        maintainers = with maintainers; [ theCapypara ];
        platforms = platforms.all;
      };
      dontBuild = true;
      installPhase = ''
        runHook preInstall
        cd $src/${subdir}
        install -dm755 "$out/share/hyphen"
        install -m644 "hyph_${dictFileName}.dic" "$out/share/hyphen"
        # docs
        install -dm755 "$out/share/doc/"
        install -m644 "README_hyph_${readmeFileName}.txt" "$out/share/doc/${pname}.txt"
        runHook postInstall
      '';
    };

in
rec {

  # ENGLISH

  en_US = en-us;
  en-us = stdenv.mkDerivation rec {
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

  # GERMAN

  de_DE = de-de;
  de-de = mkDictFromLibreofficeGit {
    subdir = "de";
    shortName = "de-de";
    shortDescription = "German (Germany)";
    dictFileName = "de_DE";
    readmeFileName = "de";
  };

  de_AT = de-at;
  de-at = mkDictFromLibreofficeGit {
    subdir = "de";
    shortName = "de-at";
    shortDescription = "German (Austria)";
    dictFileName = "de_AT";
    readmeFileName = "de";
  };

  de_CH = de-ch;
  de-ch = mkDictFromLibreofficeGit {
    subdir = "de";
    shortName = "de-ch";
    shortDescription = "German (Switzerland)";
    dictFileName = "de_CH";
    readmeFileName = "de";
  };
}
