{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libexttextcat";
  version = "3.4.6";

  src = fetchurl {
    url = "https://dev-www.libreoffice.org/src/libexttextcat/${pname}-${version}.tar.xz";
    sha256 = "sha256-bXfqziDp6hBsEzDiaO3nDJpKiXRN3CVxVoJ1TsozaN8=";
  };

  meta = with lib; {
    description = "An N-Gram-Based Text Categorization library primarily intended for language guessing";
    homepage = "https://wiki.documentfoundation.org/Libexttextcat";
    license = licenses.bsd3;
    mainProgram = "createfp";
    platforms = platforms.all;
  };
}
