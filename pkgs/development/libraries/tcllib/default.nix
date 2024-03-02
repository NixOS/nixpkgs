{ lib
, fetchzip
, tcl
, critcl
, withCritcl ? true
}:

tcl.mkTclDerivation rec {
  pname = "tcllib";
  version = "1.21";

  src = fetchzip {
    url = "mirror://sourceforge/tcllib/tcllib-${version}.tar.gz";
    hash = "sha256-p8thpRpC+9k/LvbBFaSOIpDXuhMlEWhs0qbrjtKcTzQ=";
  };

  nativeBuildInputs = lib.optional withCritcl critcl;

  buildFlags = [ "all" ] ++ lib.optional withCritcl "critcl";

  meta = {
    homepage = "https://core.tcl-lang.org/tcllib/";
    description = "Tcl-only library of standard routines for Tcl";
    license = lib.licenses.tcltk;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ fgaz ];
  };
}
