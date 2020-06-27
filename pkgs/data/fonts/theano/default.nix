{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "theano";
  version = "2.0";

  src = fetchzip {
    url = "https://github.com/akryukov/theano/releases/download/v${version}/theano-${version}.otf.zip";
    sha256 = "1z3c63rcp4vfjyfv8xwc3br10ydwjyac3ipbl09y01s7qhfz02gp";
    stripRoot = false;
  };

  meta = with lib; {
    homepage = "https://github.com/akryukov/theano";
    description = "An old-style font designed from historic samples";
    maintainers = with maintainers; [ raskin rycee ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
