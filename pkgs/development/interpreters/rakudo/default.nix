{ stdenv, fetchurl, perl, icu, zlib, gmp, lib, nqp, removeReferencesTo }:

stdenv.mkDerivation rec {
  pname = "rakudo";
  version = "2021.06";

  src = fetchurl {
    url    = "https://rakudo.org/dl/rakudo/rakudo-${version}.tar.gz";
    sha256 = "11ixlqmvbb37abksdysg5r4lkbwzr486lkc0ssl3wca4iiy3mhgf";
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
