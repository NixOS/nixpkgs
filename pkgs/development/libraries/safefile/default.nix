{ lib, stdenv, fetchurl, path, runtimeShell }:
stdenv.mkDerivation rec {
  pname = "safefile";
  version = "1.0.5";

  src = fetchurl {
    url = "http://research.cs.wisc.edu/mist/${pname}/releases/${pname}-${version}.tar.gz";
    sha256 = "1y0gikds2nr8jk8smhrl617njk23ymmpxyjb2j1xbj0k82xspv78";
  };

  meta = with lib; {
    description = "File open routines to safely open a file when in the presence of an attack";
    license = licenses.asl20;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.all;
    homepage = "https://research.cs.wisc.edu/mist/safefile/";
  };
}
