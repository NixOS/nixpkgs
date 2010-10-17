{ stdenv, hspell }:

let
  dict = a: stdenv.mkDerivation ({
    inherit (hspell) src patchPhase buildNativeInputs;
    meta = hspell.meta // {
      description = "${a.buildFlags} Hebrew dictionary";
    } // a.meta;
  } // (removeAttrs ["meta"] a));
in
{
  recurseForDerivations = true;

  aspell = dict {
    name = "aspell-dict-he-${hspell.version}";

    buildFlags = "aspell";

    installPhase = ''
      mkdir -p $out/lib/aspell
      cp -v he_affix.dat he.wl $out/lib/aspell'';
  };

  myspell = dict {
    name = "myspell-dict-he-${hspell.version}";

    buildFlags = "myspell";

    installPhase = ''
      mkdir -p $out/lib/myspell
      cp -v he.dic he.aff $out/lib/myspell'';
  };

  hunspell = dict {
    name = "hunspell-dict-he-${hspell.version}";

    buildFlags = "hunspell";

    installPhase = ''
      mkdir -p $out/lib
      cp -rv hunspell $out/lib'';
  };
}
