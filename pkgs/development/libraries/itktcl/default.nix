{ stdenv, fetchurl, tcl, tk, incrtcl }:

stdenv.mkDerivation rec {
  pname = "itk-tcl";
  version = "4.1.0";

  src = fetchurl {
    url    = "mirror://sourceforge/incrtcl/%5BIncr%20Tcl_Tk%5D-source/3.4/itk${version}.tar.gz";
    sha256 = "1iy964jfgsfnc1agk1w6bbm44x18ily8d4wmr7cc9z9f4acn2r6s";
  };

  buildInputs = [ tcl tk incrtcl ];
  enableParallelBuilding = true;

  configureFlags = [
    "--with-tcl=${tcl}/lib"
    "--with-tk=${tk}/lib"
    "--with-itcl=${incrtcl}/lib"
    "--with-tkinclude=${tk.dev}/include"
  ];

  postInstall = ''
    rmdir $out/bin
    mv $out/lib/itk${version}/* $out/lib
    rmdir $out/lib/itk${version}
  '';

  outputs = [ "out" "dev" "man" ];

  meta = with stdenv.lib; {
    homepage    = "http://incrtcl.sourceforge.net/";
    description = "Mega-widget toolkit for incr Tk";
    license     = licenses.tcltk;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
