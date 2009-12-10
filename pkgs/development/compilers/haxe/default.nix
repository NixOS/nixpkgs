args: with args;

stdenv.mkDerivation {
  name = "haxe-cvs";

  src = sourceByName "haxe";

  buildInputs = [ocaml zlib makeWrapper];

  inherit zlib;

  buildPhase = ''
    mkdir -p ocaml/{swflib,extc,extlib-dev,xml-light} neko/libs

    # strange setup. install.ml seems to co the same repo again into haxe directory!
    tar xfz $src --strip-components=1 -C haxe

    t(){ tar xfz $1 -C $2 --strip-components=2; }
    t ${sourceByName "haxe_swflib"} ocaml/swflib
    t ${sourceByName "haxe_extc"} ocaml/extc
    t ${sourceByName "haxe_extlib_dev"} ocaml/extlib-dev
    t ${sourceByName "haxe_xml_light"} ocaml/xml-light
    t ${sourceByName "haxe_neko_include"} neko/libs

    sed -e '/download();/d' \
        -e "s@/usr/lib/@''${zlib}/lib/@g" \
        doc/install.ml > install.ml
    
    ocaml install.ml
  '';

  # probably rpath should be set properly
  installPhase = ''
    ensureDir $out/lib/haxe
    cp -r bin $out/bin
    wrapProgram "$out/bin/haxe" \
      --set "LD_LIBRARY_PATH" $zlib/lib \
      --set HAXE_LIBRARY_PATH "''${HAXE_LIBRARY_PATH}''${HAXE_LIBRARY_PATH:-:}:$out/lib/haxe/std:."
    cp -r std $out/lib/haxe/
  '';

  meta = { 
    description = "programming language targeting JavaScript, Flash, NekVM, PHP, C++";
    homepage = http://haxe.org;
    license = ["GPLv2" "BSD2" /*?*/ ];  # -> docs/license.txt
    maintainers = [args.lib.maintainers.marcweber];
    platforms = args.lib.platforms.linux;
  };
}
