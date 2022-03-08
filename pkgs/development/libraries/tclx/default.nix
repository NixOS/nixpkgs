{ lib, fetchurl, tcl }:

tcl.mkTclDerivation rec {
  pname = "tclx";
  version = "8.4.1";

  src = fetchurl {
    url = "mirror://sourceforge/tclx/tclx${version}.tar.bz2";
    sha256 = "1v2qwzzidz0is58fd1p7wfdbscxm3ip2wlbqkj5jdhf6drh1zd59";
  };

  # required in order for tclx to properly detect tclx.tcl at runtime
  postInstall = let
    majorMinorVersion = lib.versions.majorMinor version;
  in ''
    ln -s $prefix/lib/tclx${majorMinorVersion} $prefix/lib/tclx${majorMinorVersion}/tclx${majorMinorVersion}
  '';

  meta = {
    homepage = "http://tclx.sourceforge.net/";
    description = "Tcl extensions";
    license = lib.licenses.tcltk;
    maintainers = with lib.maintainers; [ kovirobi ];
  };
}
