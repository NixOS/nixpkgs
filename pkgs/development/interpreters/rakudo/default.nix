{ stdenv, fetchurl, perl, icu, zlib, gmp, lib, nqp, removeReferencesTo }:

stdenv.mkDerivation rec {
  pname = "rakudo";
  version = "2021.07";

  src = fetchurl {
    url    = "https://rakudo.org/dl/rakudo/rakudo-${version}.tar.gz";
    sha256 = "0lmbgw24f8277b9kj725v3grwh1524p4iy5jbqajxwxjr16zx2hp";
  };

  nativeBuildInputs = [ removeReferencesTo ];

  buildInputs = [ icu zlib gmp perl ];
  configureScript = "perl ./Configure.pl";
  configureFlags = [
    "--backends=moar"
    "--with-nqp=${nqp}/bin/nqp"
  ];

  disallowedReferences = [ stdenv.cc.cc ];
  postFixup = ''
    remove-references-to -t ${stdenv.cc.cc} "$(readlink -f $out/share/perl6/runtime/dynext/libperl6_ops_moar.so)"
  '';

  meta = with lib; {
    description = "Raku implementation on top of Moar virtual machine";
    homepage    = "https://rakudo.org";
    license     = licenses.artistic2;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice vrthra sgo ];
  };
}
