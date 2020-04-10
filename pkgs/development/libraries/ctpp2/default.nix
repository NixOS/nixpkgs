{ stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  pname = "ctpp2";
  version = "2.8.3";

  src = fetchurl {
    url = "http://ctpp.havoc.ru/download/${pname}-${version}.tar.gz";
    sha256 = "1z22zfw9lb86z4hcan9hlvji49c9b7vznh7gjm95gnvsh43zsgx8";
  };

  buildInputs = [ cmake ];

  patchPhase = ''
    # include <unistd.h> to fix undefined getcwd
    sed -ie 's/<stdlib.h>/<stdlib.h>\n#include <unistd.h>/' src/CTPP2FileSourceLoader.cpp
  '';

  doCheck = false; # fails

  meta = with stdenv.lib; {
    description = "A high performance templating engine";
    homepage = "http://ctpp.havoc.ru";
    maintainers = [ maintainers.robbinch ];
    platforms = platforms.linux;
    license = licenses.bsd2;
  };
}
