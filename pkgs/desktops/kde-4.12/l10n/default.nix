{ stdenv, fetchurl, kdelibs, gettext, release, branch, stable }:

let

  inherit (stdenv.lib) attrByPath singleton;

  kdeL10nDerivation =
    { lang, saneName, sha256 }:

    stdenv.mkDerivation rec {
      name = "kde-l10n-${saneName}-${release}";

      src = fetchurl {
        url = "mirror://kde/${if stable then "" else "un"}stable/${release}/src/kde-l10n/kde-l10n-${lang}-${release}.tar.xz";
        name = "${name}.tar.xz";
        inherit sha256;
      };

      buildInputs = [ gettext kdelibs ];

      cmakeFlags = "-Wno-dev";

      meta = {
        description = "KDE translation for ${lang}";
        inherit branch;
        license = "GPL";
        platforms = stdenv.lib.platforms.linux;
        inherit (kdelibs.meta) maintainers homepage;
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
