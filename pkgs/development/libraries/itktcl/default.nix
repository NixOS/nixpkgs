{
  lib,
  stdenv,
  fetchurl,
  tcl,
  tk,
  incrtcl,
}:

tcl.mkTclDerivation rec {
  pname = "itk-tcl";
  version = "4.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/incrtcl/%5BIncr%20Tcl_Tk%5D-source/3.4/itk${version}.tar.gz";
    sha256 = "1iy964jfgsfnc1agk1w6bbm44x18ily8d4wmr7cc9z9f4acn2r6s";
  };

  buildInputs = [
    tk
    incrtcl
  ];
  enableParallelBuilding = true;

  configureFlags = [
    "--with-tk=${tk}/lib"
    "--with-itcl=${incrtcl}/lib"
    "--with-tkinclude=${tk.dev}/include"
  ];

  postInstall = ''
    rmdir $out/bin
    mv $out/lib/itk${version}/* $out/lib
    ln -s libitk${version}${stdenv.hostPlatform.extensions.sharedLibrary} \
      $out/lib/libitk${lib.versions.major version}${stdenv.hostPlatform.extensions.sharedLibrary}
    rmdir $out/lib/itk${version}
  '';

  outputs = [
    "out"
    "dev"
    "man"
  ];

  meta = with lib; {
    homepage = "https://incrtcl.sourceforge.net/";
    description = "Mega-widget toolkit for incr Tk";
    license = licenses.tcltk;
    platforms = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
