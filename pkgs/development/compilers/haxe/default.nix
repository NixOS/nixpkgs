{ stdenv, fetchsvn, ocaml, zlib, neko }:

stdenv.mkDerivation {
  name = "haxe-3.00";

  buildInputs = [ocaml zlib neko];

  srcs = fetchsvn {
    url = "http://haxe.googlecode.com/svn/trunk";
    sha256 = "0yfqqyr2jyd9b15xadcvv3fiaipxzgnilqnbbgd6pnaj1zsm31lr";
    rev = 6706;
    ignoreExternals = true;
  };

  ocamllibs = fetchsvn {
    url = "http://ocamllibs.googlecode.com/svn/trunk";
    sha256 = "0ngcsp1qksz98r3qixj1b3l2k9qp7wgn7jxc2fpl8pvv9bc3b52f";
    rev = 287;
    ignoreExternals = true;
  };

  prePatch = ''
    cp -r "$ocamllibs" libs
    chmod -R u+w libs
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
