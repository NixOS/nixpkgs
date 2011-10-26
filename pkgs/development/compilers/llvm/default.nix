{ stdenv, fetchurl, perl, groff, darwinSwVersUtility }:

let version = "2.9"; in

stdenv.mkDerivation {
  name = "llvm-${version}";

  src = fetchurl {
    url    = "http://llvm.org/releases/${version}/llvm-${version}.tgz";
    sha256 = "0y9pgdakn3n0vf8zs6fjxjw6972nyw4rkfwwza6b8a3ll77kc4k6";
  };

  buildInputs = [ perl groff ] ++
    stdenv.lib.optional stdenv.isDarwin darwinSwVersUtility;

  configureFlags = [ "--enable-optimized" "--enable-shared" "--disable-static" ]
    ++ stdenv.lib.optionals (stdenv.gcc ? clang) [
      "--with-built-clang=yes"
      "CXX=clang++"
    ];

  meta = {
    homepage = http://llvm.org/;
    description = "Collection of modular and reusable compiler and toolchain technologies";
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric shlevy];
    platforms = with stdenv.lib.platforms; all;
  };
}

