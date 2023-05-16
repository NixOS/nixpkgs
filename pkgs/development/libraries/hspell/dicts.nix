<<<<<<< HEAD
{ lib, stdenv, hspell }:
=======
{ stdenv, hspell }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

let
  dict = variant: a: stdenv.mkDerivation ({
    inherit (hspell) version src patchPhase nativeBuildInputs;
    buildFlags = [ variant ];

    meta = hspell.meta // {
      broken = true;
      description = "${variant} Hebrew dictionary";
<<<<<<< HEAD
    } // (lib.optionalAttrs (a ? meta) a.meta);
=======
    } // (if a ? meta then a.meta else {});
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  } // (removeAttrs a ["meta"]));
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
