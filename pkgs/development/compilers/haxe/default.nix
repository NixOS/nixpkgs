{ stdenv, fetchgit, ocaml, zlib, pcre, neko, camlp4 }:

stdenv.mkDerivation {
  name = "haxe-3.4.2";

  buildInputs = [ocaml zlib pcre neko camlp4];

  src = fetchgit {
    url = "https://github.com/HaxeFoundation/haxe.git";
    sha256 = "1m5fp183agqv8h3ynhxw4kndkpq2d6arysmirv3zl3vz5crmpwqd";
    fetchSubmodules = true;

    # Tag 3.4.2
    rev = "890f8c70cf23ce6f9fe0fdd0ee514a9699433ca7";
  };

  prePatch = ''
    sed -i -e 's|"/usr/lib/haxe/std/";|"'"$out/lib/haxe/std/"'";\n&|g' src/main.ml
  '';

  buildFlags = [ "all" "tools" ];

  installPhase = ''
    install -vd "$out/bin" "$out/lib/haxe/std"
    install -vt "$out/bin" haxe haxelib
    cp -vr std "$out/lib/haxe"
  '';

  setupHook = ./setup-hook.sh;

  dontStrip = true;

  meta = with stdenv.lib; {
    description = "Programming language targeting JavaScript, Flash, NekoVM, PHP, C++";
    homepage = https://haxe.org;
    license = with licenses; [ gpl2 bsd2 /*?*/ ];  # -> docs/license.txt
    maintainers = [ maintainers.marcweber ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
