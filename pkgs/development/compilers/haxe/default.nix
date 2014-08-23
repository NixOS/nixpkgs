{ stdenv, fetchgit, ocaml, zlib, neko }:

stdenv.mkDerivation {
  name = "haxe-3.1.3";

  buildInputs = [ocaml zlib neko];

  src = fetchgit {
    url = "https://github.com/HaxeFoundation/haxe.git";
    sha256 = "1p4yja6flv2r04q9lcrjxia3f3fsmhi3d88s0lz0nf0r4m61bjz0";
    fetchSubmodules = true;

    # Tag 3.1.3
    rev = "7be30670b2f1f9b6082499c8fb9e23c0a6df6c28";
  };

  prePatch = ''
    sed -i -e 's|com.class_path <- \[|&"'"$out/lib/haxe/std/"'";|' main.ml
  '';

  buildFlags = [ "all" "tools" ];

  installPhase = ''
    install -vd "$out/bin" "$out/lib/haxe/std"
    install -vt "$out/bin" haxe haxelib
    cp -vr std "$out/lib/haxe"
  '';

  dontStrip = true;

  meta = {
    description = "Programming language targeting JavaScript, Flash, NekoVM, PHP, C++";
    homepage = http://haxe.org;
    license = ["GPLv2" "BSD2" /*?*/ ];  # -> docs/license.txt
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
