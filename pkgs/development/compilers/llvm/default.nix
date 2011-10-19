{ stdenv, fetchurl, perl, groff }:

let version = "2.9"; in

stdenv.mkDerivation {
  name = "llvm-${version}";

  CC = if stdenv.gcc ? clang then "clang" else "gcc";

  CXX = if stdenv.gcc ? clang then "clang++" else "g++";

  src = fetchurl {
    url    = "http://llvm.org/releases/${version}/llvm-${version}.tgz";
    sha256 = "0y9pgdakn3n0vf8zs6fjxjw6972nyw4rkfwwza6b8a3ll77kc4k6";
  };

  buildInputs = [ perl groff ];

  configureFlags = [ "--enable-optimized" "--enable-shared" "--disable-static" ];

  meta = {
    homepage = http://llvm.org/;
    description = "Collection of modular and reusable compiler and toolchain technologies";
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric shlevy];
    platforms = with stdenv.lib.platforms; all;
  };
}

