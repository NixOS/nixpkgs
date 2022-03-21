{ lib, stdenv, fetchurl, pkg-config, pure, tcl, tk, xlibsWrapper }:

stdenv.mkDerivation rec {
  pname = "pure-tk";
  version = "0.5";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/pure-tk-${version}.tar.gz";
    sha256 = "3b6e97e2d723d5a05bf25f4ac62068ac17a1fd81db03e1986366097bf071a516";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ pure tcl tk xlibsWrapper ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "A basic interface between Pure and Tcl/Tk";
    homepage = "http://puredocs.bitbucket.org/pure-tk.html";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ asppsa ];
  };
}
