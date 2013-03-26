{ stdenv, fetchsvn, ocaml, zlib, neko }:

stdenv.mkDerivation {
  name = "haxe-2.10";

  buildInputs = [ocaml zlib neko];

  srcs = fetchsvn {
    url = "http://haxe.googlecode.com/svn/tags/v2-10";
    sha256 = "0vwdlj0vmmf97bg6cish7yah36aca2q599vwzbr1m0jpjbvindkh";
    ignoreExternals = true;
  };

  ocamllibs = fetchsvn {
    url = "http://ocamllibs.googlecode.com/svn/trunk";
    sha256 = "143s320xn2xalm0lnw46h1fvy48qg7my3j8cf66f0wwzv2fisr1q";
    rev = 256;
    ignoreExternals = true;
  };

  prePatch = ''
    cp -r "$ocamllibs" libs
    chmod -R u+w libs
    sed -i -e 's|com.class_path <- \[|&"'"$out/lib/haxe/std/"'";|' main.ml
  '';

  postBuild = ''
    find std/tools -name '*.n' -delete
    rm std/tools/haxedoc/haxedoc std/tools/haxelib/haxelib
  '';

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
