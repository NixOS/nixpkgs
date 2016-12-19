{ stdenv, fetchzip, haxe, neko, pcre, sqlite, zlib }:

stdenv.mkDerivation rec {
  name = "hxcpp-3.2.27";

  src = let
    zipFile = stdenv.lib.replaceChars ["."] [","] name;
  in fetchzip {
    inherit name;
    url = "http://lib.haxe.org/files/3.0/${zipFile}.zip";
    sha256 = "1hw4kr1f8q7f4fkzis7kvkm7h1cxhv6cf5v1iq7rvxs2fxiys7fr";
  };

  NIX_LDFLAGS = "-lpcre -lz -lsqlite3";

  outputs = [ "out" "lib" ];

  patchPhase = ''
    rm -rf bin lib project/thirdparty project/libs/sqlite/sqlite3.[ch]
    find . -name '*.n' -delete
    sed -i -re '/(PCRE|ZLIB)_DIR|\<sqlite3\.c\>/d' project/Build.xml
    sed -i -e 's/mFromFile = "@";/mFromFile = "";/' tools/hxcpp/Linker.hx
    sed -i -e '/dll_ext/s,HX_CSTRING("./"),HX_CSTRING("'"$lib"'/"),' \
      src/hx/Lib.cpp
  '';

  buildInputs = [ haxe neko pcre sqlite zlib ];

  targetArch = "linux-m${if stdenv.is64bit then "64" else "32"}";

  buildPhase = ''
    haxe -neko project/build.n -cp tools/build -main Build
    haxe -neko run.n -cp tools/run -main RunMain
    haxe -neko hxcpp.n -cp tools/hxcpp -main BuildTool
    (cd project && neko build.n "ndll-$targetArch")
  '';

  installPhase = ''
    for i in bin/Linux*/*.dso; do
      install -vD "$i" "$lib/$(basename "$i")"
    done
    find *.n toolchain/*.xml build-tool/BuildCommon.xml src include \
      -type f -exec install -vD -m 0644 {} "$out/lib/haxe/hxcpp/{}" \;
  '';

  meta = {
    homepage = "http://lib.haxe.org/p/hxcpp";
    description = "Runtime support library for the Haxe C++ backend";
    license = stdenv.lib.licenses.bsd2;
    platforms = stdenv.lib.platforms.linux;
  };
}
