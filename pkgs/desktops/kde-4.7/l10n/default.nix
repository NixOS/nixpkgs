{ stdenv, fetchurl, cmake, kdelibs, gettext, perl, automoc4, qt4, phonon, release }:

let

  inherit (stdenv.lib) attrByPath singleton;

  kdeL10nDerivation =
    { lang, saneName, sha256 }:
    
    stdenv.mkDerivation rec {
      name = "kde-l10n-${saneName}-${release}";
      
      src = fetchurl {
        url = "mirror://kde/stable/${release}/src/kde-l10n/kde-l10n-${lang}-${release}.tar.bz2";
        name = "${name}.tar.bz2";
        inherit sha256;
      };

      buildInputs = [ cmake perl gettext kdelibs automoc4 qt4 phonon ];

      meta = {
        description = "KDE translation for ${lang}";
        license = "GPL";
        inherit (kdelibs.meta) maintainers platforms homepage;
      };
    };

  kdeL10nRelease =
    builtins.listToAttrs (
      map ({lang, saneName, sha256}:
        {
          name = saneName;
          value = kdeL10nDerivation { inherit lang saneName sha256; };
        }
      ) (import (./manifest + "-${release}.nix"))
    );

in
{
  inherit kdeL10nDerivation;
  recurseForDerivations = true;
} // kdeL10nRelease
