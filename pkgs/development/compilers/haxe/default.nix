{ stdenv, fetchsvn, ocaml, zlib, neko }:

stdenv.mkDerivation {
  name = "haxe-3.00";

  buildInputs = [ocaml zlib neko];

  src = fetchsvn {
    url = "http://haxe.googlecode.com/svn/trunk";
    sha256 = "0hg8qailhgrcdk7r4k9kmwfl9d9ds0vy0l7wbv5wdrrc34qzifm4";
    rev = 6706;
  };

  prePatch = ''
    sed -i -e 's|com.class_path <- \[|&"'"$out/lib/haxe/std/"'";|' main.ml
  '';

  postBuild = ''
    find std/tools -name '*.n' -delete
    rm -f std/tools/haxedoc/haxedoc std/tools/haxelib/haxelib
  '';

  buildFlags = [ "all" "tools" ];

  installPhase = ''
    install -vd "$out/bin" "$out/lib/haxe/std"
    install -vt "$out/bin" haxe haxelib haxedoc
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
