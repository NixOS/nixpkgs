{ stdenv, hspell }:

let
  dict = variant: a: stdenv.mkDerivation ({
    inherit (hspell) src patchPhase nativeBuildInputs;
    buildFlags = [ variant ];

    meta = hspell.meta // {
      broken = true;
      description = "${variant} Hebrew dictionary";
    } // (if a ? meta then a.meta else {});
  } // (removeAttrs a ["meta"]));
in
{
  recurseForDerivations = true;

  aspell = dict "aspell" {
    name = "aspell-dict-he-${hspell.version}";

    installPhase = ''
      mkdir -p $out/lib/aspell
      cp -v he_affix.dat he.wl $out/lib/aspell'';
  };

  myspell = dict "myspell" {
    name = "myspell-dict-he-${hspell.version}";

    installPhase = ''
      mkdir -p $out/lib/myspell
      cp -v he.dic he.aff $out/lib/myspell'';
  };

  hunspell = dict "hunspell" {
    name = "hunspell-dict-he-${hspell.version}";

    installPhase = ''
      mkdir -p $out/lib
      cp -rv hunspell $out/lib'';
  };
}
