{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libhangul";
  version = "0.1.0";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/libhangul/libhangul-${version}.tar.gz";
    sha256 = "0ni9b0v70wkm0116na7ghv03pgxsfpfszhgyj3hld3bxamfal1ar";
  };

  meta = with lib; {
    description = "Core algorithm library for Korean input routines";
    mainProgram = "hangul";
    homepage = "https://github.com/choehwanjin/libhangul";
    license = licenses.lgpl21;
    maintainers = [ maintainers.ianwookim ];
    platforms = platforms.linux;
  };
}
