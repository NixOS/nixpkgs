{ stdenv, agda, fetchurl }:

agda.mkDerivation (self: rec {
  version = "0.1";
  name = "agda-base-${version}";

  src = fetchurl {
    url = "https://github.com/pcapriotti/agda-base/archive/v${version}.tar.gz";
    sha256 = "124h06p7jdiqr2x6r46sfab9r0cgb0fznr2qs5i1psl5yf3z74h8";
  };

  sourceDirectories = [ "./." ];
  everythingFile = "README.agda";

  meta = {
    homepage = https://github.com/pcapriotti/agda-base;
    description = "Base library for HoTT in Agda";
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
    broken = true;  # largely replaced by HoTT-Agda
  };
})
