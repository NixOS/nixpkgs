{ stdenv, fetchurl, tcl }:

stdenv.mkDerivation rec {
  name = "tclx-${version}.${patch}";
  version = "8.4";
  patch = "1";

  src = fetchurl {
    url = "mirror://sourceforge/tclx/tclx${version}.${patch}.tar.bz2";
    sha256 = "1v2qwzzidz0is58fd1p7wfdbscxm3ip2wlbqkj5jdhf6drh1zd59";
  };

  passthru = {
    libPrefix = ""; # Using tclx${version} did not work
  };

  buildInputs = [ tcl ];

  configureFlags = [ "--with-tcl=${tcl}/lib" "--exec-prefix=\${prefix}" ];

  meta = {
    homepage = http://tclx.sourceforge.net/;
    description = "Tcl extensions";
    license = stdenv.lib.licenses.tcltk;
    maintainers = with stdenv.lib.maintainers; [ kovirobi ];
  };
}
