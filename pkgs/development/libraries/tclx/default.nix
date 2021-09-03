{ lib, fetchurl, tcl }:

tcl.mkTclDerivation rec {
  name = "tclx-${version}.${patch}";
  version = "8.4";
  patch = "1";

  src = fetchurl {
    url = "mirror://sourceforge/tclx/tclx${version}.${patch}.tar.bz2";
    sha256 = "1v2qwzzidz0is58fd1p7wfdbscxm3ip2wlbqkj5jdhf6drh1zd59";
  };

  # required in order for tclx to properly detect tclx.tcl at runtime
  postInstall = ''
    ln -s $prefix/lib/tclx${version} $prefix/lib/tclx${version}/tclx${version}
  '';

  meta = {
    homepage = "http://tclx.sourceforge.net/";
    description = "Tcl extensions";
    license = lib.licenses.tcltk;
    maintainers = with lib.maintainers; [ kovirobi ];
  };
}
