{ stdenv, fetchgit, ocaml, zlib, neko, camlp4 }:

stdenv.mkDerivation {
  name = "haxe-3.2.1";

  buildInputs = [ocaml zlib neko camlp4];

  src = fetchgit {
    url = "https://github.com/HaxeFoundation/haxe.git";
    sha256 = "1x9ay5a2llq46fww3k07jxx8h1vfpyxb522snc6702a050ki5vz3";
    fetchSubmodules = true;

    # Tag 3.2.1
    rev = "deab4424399b520750671e51e5f5c2684e942c17";
  };

  prePatch = ''
    sed -i -e 's|com.class_path <- \[|&"'"$out/lib/haxe/std/"'";|' main.ml
  '';

  patches = [ ./haxelib-nix.patch ];

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
    homepage = http://haxe.org;
    license = with licenses; [ gpl2 bsd2 /*?*/ ];  # -> docs/license.txt
    maintainers = [ maintainers.marcweber ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
