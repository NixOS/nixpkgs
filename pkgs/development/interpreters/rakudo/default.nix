{ stdenv, fetchFromGitHub, perl, icu, zlib, gmp, lib, nqp, removeReferencesTo }:

stdenv.mkDerivation rec {
  pname = "rakudo";
<<<<<<< HEAD
  version = "2023.08";
=======
  version = "2023.04";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "rakudo";
    repo = "rakudo";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-wvHMyXMkI2RarmUeC8lKGgy3TNmVQsZo/3D/eS4FUrI=";
=======
    hash = "sha256-m5rXriBKfp/i9AIcBGCYGfXIGBRsxgVmBbLJPXXc5AY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
