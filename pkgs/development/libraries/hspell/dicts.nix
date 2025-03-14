{
  lib,
  stdenv,
  hspell,
}:

let
  dict =
    variant: a:
    stdenv.mkDerivation (
      {
        inherit (hspell)
          version
          src
          patches
          postPatch
          nativeBuildInputs
          ;
        buildFlags = [ variant ];

        meta =
          hspell.meta
          // {
            broken = true;
            description = "${variant} Hebrew dictionary";
          }
          // (lib.optionalAttrs (a ? meta) a.meta);
      }
      // (removeAttrs a [ "meta" ])
    );
in
{
  recurseForDerivations = true;

  aspell = dict "aspell" {
    pname = "aspell-dict-he";

    installPhase = ''
      mkdir -p $out/lib/aspell
      cp -v he_affix.dat he.wl $out/lib/aspell'';
  };

  myspell = dict "myspell" {
    pname = "myspell-dict-he";

    installPhase = ''
      mkdir -p $out/lib/myspell
      cp -v he.dic he.aff $out/lib/myspell'';
  };

  hunspell = dict "hunspell" {
    pname = "hunspell-dict-he";

    installPhase = ''
      mkdir -p $out/lib
      cp -rv hunspell $out/lib'';
  };
}
