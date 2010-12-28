{ stdenv, fetchurl, cmake, kdelibs, gettext, perl, automoc4 }:

let
  overrides = { };

  defaultRelease = "4.5.90";
  releases = [ "4.5.90" ];

  sanitizeString = replaceChars [ "@" "." ] [ "_" "_" ];
  getOverride = name: attrByPath [name] {} overrides;

  inherit (stdenv.lib) replaceChars attrByPath singleton;

  kdeL10nDerivation = {lang, sha256, release} :
    let
      name = "kde-l10n-${lang}-${release}";
      saneName = "kde-l10n-${sanitizeString lang}-${release}";
    in
    stdenv.mkDerivation ({
      name = saneName;
      src = fetchurl {
        url = "mirror://kde/unstable/${release}/src/kde-l10n/${name}.tar.bz2";
        name = "${saneName}.tar.bz2";
        inherit sha256;
      };

      buildInputs = [ cmake perl gettext kdelibs automoc4 ];

      meta = {
        description = "KDE translation for ${lang}";
        license = "GPL";
        inherit (kdelibs.meta) maintainers platforms homepage;
      };
    }
    // (getOverride lang) // (getOverride name)
  );

  kdeL10nRelease = release:
    let
      releaseStr = sanitizeString release;
    in
    builtins.listToAttrs (
      map ({lang, sha256}:
        {
          name = "${sanitizeString lang}";
          value = kdeL10nDerivation { inherit lang release sha256;};
        }
      ) (import (./manifest + "-${release}.nix"))
    );

in
{
  inherit kdeL10nDerivation;
  recurseForDerivations = true;
}
// builtins.listToAttrs (map (r : { name = sanitizeString r; value =
kdeL10nRelease r; }) releases)
// (kdeL10nRelease defaultRelease)
