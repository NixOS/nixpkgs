{ stdenv, fetchFromGitHub, perl, icu, zlib, gmp, lib, nqp, removeReferencesTo }:

stdenv.mkDerivation rec {
  pname = "rakudo";
  version = "2023.06";

  src = fetchFromGitHub {
    owner = "rakudo";
    repo = "rakudo";
    rev = version;
    hash = "sha256-t+zZEokjcDXp8uuHaOHp1R9LuS0Q3CSDOWhbSFXlNaU=";
    fetchSubmodules = true;
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
    remove-references-to -t ${stdenv.cc.cc} "$(readlink -f $out/share/perl6/runtime/dynext/libperl6_ops_moar${stdenv.hostPlatform.extensions.sharedLibrary})"
  '';

  meta = with lib; {
    description = "Raku implementation on top of Moar virtual machine";
    homepage = "https://rakudo.org";
    license = licenses.artistic2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice vrthra sgo ];
  };
}
