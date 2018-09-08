{ stdenv, autoreconfHook, fetchurl, tk, tcl, otcl, xlibs, zlib }:
stdenv.mkDerivation rec {
  version = "1.20";

  name = "tclcl-${version}";

  src = fetchurl {
    url = "https://sourceforge.net/projects/otcl-tclcl/files/TclCL/${version}/tclcl-src-${version}.tar.gz";
    sha256 = "0y6w0vrszhmggq8j20phsg2h9n12hjzi0zlawllk5hfin721xzb4";
  };

  CFLAGS = "-DUSE_INTERP_ERRORLINE -DUSE_INTERP_RESULT";

  postPatch = ''
    # Makefile seems to be ignoring CFLAGS
    substituteInPlace Makefile.in \
      --replace 'CFLAGS'' + "\t" + ''= ' 'CFLAGS = @CFLAGS@ ' 

    substituteInPlace conf/configure.in.z \
      --replace 'ZLIB_H_PLACES_D="$d' 'ZLIB_H_PLACES_D="${zlib.dev}/include'

    substituteInPlace conf/configure.in.tk \
      --replace 'TK_H_PLACES_D="$d' 'TK_H_PLACES_D="${tk.dev}/include'
  '';

  nativeBuildInputs = [ 
    autoreconfHook 
    xlibs.libX11 xlibs.libXt xlibs.libXext 
    ];

  configureFlags = [
    "--with-tcl=${tcl}"
    "--with-tcl-ver=${tcl.release}"
    "--with-tk=${tk}"
    "--with-tk-ver=${tk.release}"
    "--with-otcl=${otcl}"
    "--with-zlib=${zlib}"
  ];

  preInstall = ''
    mkdir -p $out/include
    mkdir -p $out/lib
    mkdir -p $out/bin
  '';

  meta = with stdenv.lib; {
    description = "A Tcl/C++ interface";
    homepage = http://otcl-tclcl.sourceforge.net/tclcl/;
    license = licenses.free;
    maintainers = [ maintainers.pschuprikov ];
    platforms = platforms.unix;
  };
}
