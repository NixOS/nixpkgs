{ stdenv
, lib
, fetchurl
, optimize ? false # impure hardware optimizations
}:
stdenv.mkDerivation rec {
  name = "gf2x-${version}";
  version = "1.2"; # remember to also update the url

  src = fetchurl {
    # find link to latest version (with file id) here: https://gforge.inria.fr/projects/gf2x/
    # Requested a predictable link:
    # https://gforge.inria.fr/tracker/index.php?func=detail&aid=21704&group_id=1874&atid=6982
    url = "https://gforge.inria.fr/frs/download.php/file/36934/gf2x-${version}.tar.gz";
    sha256 = "0d6vh1mxskvv3bxl6byp7gxxw3zzpkldrxnyajhnl05m0gx7yhk1";
  };

  # no actual checks present yet (as of 1.2), but can't hurt trying
  # for an indirect test, run ntl's test suite
  doCheck = true;

  configureFlags = lib.optionals (!optimize) [
    "--disable-hardware-specific-code"
  ];

  meta = with lib; {
    description = ''Routines for fast arithmetic in GF(2)[x]'';
    homepage = http://gf2x.gforge.inria.fr;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ raskin timokau ];
    platforms = platforms.unix;
  };
}
