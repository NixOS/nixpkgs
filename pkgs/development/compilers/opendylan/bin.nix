# Binaries provided by Open Dylan to be used to bootstrap from source.
# The binaries can also be used as is.
{stdenv, fetchurl, patchelf, boehmgc, gnused, gcc, makeWrapper}:

stdenv.mkDerivation {
  name = "opendylan-2013.2";

  src = if stdenv.system == "x86_64-linux" then fetchurl {
      url = http://opendylan.org/downloads/opendylan/2013.2/opendylan-2013.2-x86_64-linux.tar.bz2;
      sha256 = "035brbw3hm7zrs593q4zc42yglj1gmmkw3b1r7zzlw3ks4i2lg7h";
    }
    else if stdenv.system == "i686-linux" then fetchurl {
      url = http://opendylan.org/downloads/opendylan/2013.2/opendylan-2013.2-x86-linux.tar.bz2;
      sha256 = "0c61ihvblcsjrw6ncr8x8ylhskcrqs8pajs4mg5di36cvqw12nq5";
    }
    else throw "platform ${stdenv.system} not supported.";

  buildInputs = [ patchelf boehmgc gnused makeWrapper ];

  buildCommand = ''
    mkdir -p "$out"
    tar --strip-components=1 -xjf "$src" -C "$out"

    interpreter="$(cat "$NIX_CC"/nix-support/dynamic-linker)"
    for a in "$out"/bin/*; do 
      patchelf --set-interpreter "$interpreter" "$a"
      patchelf --set-rpath "$out/lib:${boehmgc.out}/lib" "$a"
    done
    for a in "$out"/lib/*.so; do 
      patchelf --set-rpath "$out/lib:${boehmgc.out}/lib" "$a"
    done
    sed -i -e "s|\-lgc|\-L${boehmgc.out}\/lib -lgc|" $out/lib/config.jam
    wrapProgram $out/bin/dylan-compiler --suffix PATH : ${gcc}/bin
  '';

  meta = {
    homepage = http://opendylan.org;
    description = "A multi-paradigm functional and object-oriented programming language";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
  };
}
