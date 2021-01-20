{ lib, stdenv, fetchurl, pkg-config, efl, pcre, mesa, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "ephoto";
  version = "1.5";

  src = fetchurl {
    url = "http://www.smhouston.us/stuff/${pname}-${version}.tar.gz";
    sha256 = "09kraa5zz45728h2dw1ssh23b87j01bkfzf977m48y1r507sy3vb";
  };

  nativeBuildInputs = [
    pkg-config
    mesa.dev # otherwise pkg-config does not find gbm
    makeWrapper
  ];

  buildInputs = [
    efl
    pcre
  ];

  meta = {
    description = "Image viewer and editor written using the Enlightenment Foundation Libraries";
    homepage = "https://smhouston.us/projects/ephoto/";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.romildo ];
  };
}
