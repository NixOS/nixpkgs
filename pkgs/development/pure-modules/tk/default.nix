{ stdenv, fetchurl, pkgconfig, pure, tcl, tk, xlibsWrapper }:

stdenv.mkDerivation rec {
  baseName = "tk";
  version = "0.5";
  name = "pure-${baseName}-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/${name}.tar.gz";
    sha256 = "3b6e97e2d723d5a05bf25f4ac62068ac17a1fd81db03e1986366097bf071a516";
  };

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ pure tcl tk xlibsWrapper ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "A basic interface between Pure and Tcl/Tk";
    homepage = http://puredocs.bitbucket.org/pure-tk.html;
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ asppsa ];
  };
}
