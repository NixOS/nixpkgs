{ stdenv, fetchsvn, autoconf, automake, tcl, tcllib, gnupg }:

stdenv.mkDerivation rec {
  name = "tclgpg-${version}";
  version = "1.0pre";

  src = fetchsvn {
    url = "http://tclgpg.googlecode.com/svn/trunk";
    rev = 74;
    sha256 = "5207b1d246fea6d4527e8c044579dae45a2e31eeaa5633f4f97c7e7b54ec27c5";
  };

  configureFlags = "--with-tcl=" + tcl + "/lib "
                 + "--with-tclinclude=" + tcl + "/include ";

  preConfigure = ''
    configureFlags="--exec_prefix=$prefix $configureFlags"
    sed -i -e 's|dtplite|TCLLIBPATH="${tcllib}/lib/tcllib${tcllib.version}" &|' Makefile.in
    autoreconf -vfi
  '';

  prePatch = ''
    sed -i -e 's|\[auto_execok gpg\]|"${gnupg}/bin/gpg2"|' tclgpg.tcl
  '';

  passthru = {
    libPrefix = "gpg1.0";
  };

  buildInputs = [ autoconf automake tcl tcllib ];

  meta = {
    homepage = http://code.google.com/p/tclgpg/;
    description = "A Tcl interface to GNU Privacy Guard";
    license = stdenv.lib.licenses.bsd2;
  };
}
