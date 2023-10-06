{ lib
, fetchurl
, tcl
, critcl
, withCritcl ? true
}:

tcl.mkTclDerivation rec {
  pname = "tcllib";
  version = "1.21";

  src = fetchurl {
    url = "mirror://sourceforge/tcllib/tcllib-${version}.tar.gz";
    sha256 = "sha256-RrK7XsgEk2OuAWRa8RvaO9tdsQYp6AfYHRrUbNG+rVA=";
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
