{ stdenv, fetchurl, cmake, kdelibs, gettext, perl, automoc4 }:

let
  overrides = { };

  defaultVersion = "4.5.1";

  getOverride = name: stdenv.lib.attrByPath [name] {} overrides;

  kdeL10nDerivation = {lang, sha256, version} :
    let
      name = "kde-l10n-${lang}-${version}";
    in
    stdenv.mkDerivation ({
      inherit name;
      src = fetchurl {
        url = "mirror://kde/stable/${version}/src/kde-l10n/${name}.tar.bz2";
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
in
{
  inherit kdeL10nDerivation;
  recurseForDerivations = true;
}
// (builtins.listToAttrs (
  map (a@{lang, version, sha256} :
      {
        name = stdenv.lib.replaceChars ["." "@"] ["_" "_"] "${lang}_${version}";
        value = kdeL10nDerivation a;
      }
    ) (import ./manifest.nix)
))
// (builtins.listToAttrs (
  map (a@{lang, version, sha256} :
      {
        name = stdenv.lib.replaceChars ["." "@"] ["_" "_"] "${lang}";
        value = kdeL10nDerivation a;
      }
    ) (stdenv.lib.filter (x : x.version == defaultVersion) (import ./manifest.nix))
))
