{ stdenv
, fetchurl
}:

stdenv.mkDerivation rec {
  pname = "rankwidth";
  version = "0.7";

  src = fetchurl {
    url = "mirror://sageupstream/rw/rw-${version}.tar.gz";
    sha256 = "1rv2v42x2506x7f10349m1wpmmfxrv9l032bkminni2gbip9cjg0";
  };

  configureFlags = [
    "--enable-executable=no" # no igraph dependency
  ];

  # check phase is empty for now (as of version 0.7)
  doCheck = true;

  meta = with stdenv.lib; {
    description = "Calculates rank-width and rank-decompositions";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ timokau ];
    platforms = platforms.linux;
  };
}
