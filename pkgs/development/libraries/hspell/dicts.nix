{ stdenv, hspell }:

let
  dict = a: stdenv.mkDerivation ({
    inherit (hspell) src patchPhase nativeBuildInputs;
    meta = hspell.meta // {
      description = "${a.buildFlags} Hebrew dictionary";
    } // (if a ? meta then a.meta else {});
  } // (removeAttrs a ["meta"]));
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
