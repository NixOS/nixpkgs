{ stdenv, fetchurl, boehmgc, zlib, sqlite, pcre }:

stdenv.mkDerivation rec {
  name = "neko-${version}";
  version = "1.8.2";

  src = fetchurl {
    url = "http://nekovm.org/_media/neko-${version}.tar.gz";
    sha256 = "099727w6dk689z3pcgbhsqjl74zzrh82a5vb2abxynamcqxcgz1w";
  };

  prePatch = with stdenv.lib; let
    libs = concatStringsSep "," (map (lib: "\"${lib}/include\"") buildInputs);
  in ''
    sed -i -e '/^search_includes/,/^}/c \
      search_includes = function(_) { return $array(${libs}) }
    ' src/tools/install.neko
    sed -i -e '/allocated = strdup/s|"[^"]*"|"'"$out/lib/neko:$out/bin"'"|' \
      vm/load.c
    # temporarily, fixed in 1.8.3
    sed -i -e 's/^#if defined(_64BITS)/& || defined(__x86_64__)/' vm/neko.h

    for disabled_mod in mod_neko{,2} mod_tora{,2} mysql ui; do
      sed -i -e '/^libs/,/^}/{/^\s*'"$disabled_mod"'\s*=>/,/^\s*}/d}' \
        src/tools/install.neko
    done
  '';

  makeFlags = "INSTALL_PREFIX=$(out)";
  buildInputs = [ boehmgc zlib sqlite pcre ];
  dontStrip = true;

  preInstall = ''
    install -vd "$out/lib" "$out/bin"
  '';

  meta = {
    description = "A high-level dynamically typed programming language";
    homepage = http://nekovm.org;
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
