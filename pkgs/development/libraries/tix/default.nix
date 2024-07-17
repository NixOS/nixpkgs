{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  tcl,
  tk,
}:

tcl.mkTclDerivation {
  version = "8.4.3";
  pname = "tix";
  src = fetchurl {
    url = "mirror://sourceforge/tix/tix/8.4.3/Tix8.4.3-src.tar.gz";
    sha256 = "1jq3dkyk9mqkj4cg7mdk5r0cclqsby9l2b7wrysi0zk5yw7h8bsn";
  };
  patches =
    [
      (fetchpatch {
        name = "tix-8.4.3-tcl8.5.patch";
        url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/dev-tcltk/tix/files/tix-8.4.3-tcl8.5.patch?id=56bd759df1d0c750a065b8c845e93d5dfa6b549d";
        sha256 = "0wzqmcxxq0rqpnjgxz10spw92yhfygnlwv0h8pcx2ycnqiljz6vj";
      })
      # Remove duplicated definition of XLowerWindow
      ./duplicated-xlowerwindow.patch
      # Fix incompatible function pointer conversions and implicit definition of `panic`.
      # `panic` is just `Tcl_Panic`, but it is not defined on Darwin due to a conflict with `mach/mach.h`.
      ./fix-clang16.patch
    ]
    ++ lib.optional (tcl.release == "8.6") (fetchpatch {
      name = "tix-8.4.3-tcl8.6.patch";
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/dev-tcltk/tix/files/tix-8.4.3-tcl8.6.patch?id=56bd759df1d0c750a065b8c845e93d5dfa6b549d";
      sha256 = "1jaz0l22xj7x1k4rb9ia6i1psnbwk4pblgq4gfvya7gg7fbb7r36";
    });
  buildInputs = [ tk ];
  # the configure script expects to find the location of the sources of
  # tcl and tk in {tcl,tk}Config.sh
  # In fact, it only needs some private headers. We copy them in
  # the private_headers folders and trick the configure script into believing
  # the sources are here.
  preConfigure = ''
    mkdir -p private_headers/generic
    < ${tcl}/lib/tclConfig.sh sed "s@TCL_SRC_DIR=.*@TCL_SRC_DIR=private_headers@" > tclConfig.sh
    < ${tk}/lib/tkConfig.sh sed "s@TK_SRC_DIR=.*@TK_SRC_DIR=private_headers@" > tkConfig.sh
    for i in ${tcl}/include/* ${tk.dev}/include/*; do
      ln -s $i private_headers/generic;
    done;
  '';
  addTclConfigureFlags = false;
  configureFlags = [
    "--with-tclconfig=."
    "--with-tkinclude=${tk.dev}/include"
    "--with-tkconfig=."
    "--libdir=\${prefix}/lib"
  ];

  meta = with lib; {
    description = "A widget library for Tcl/Tk";
    homepage = "https://tix.sourceforge.net/";
    platforms = platforms.all;
    license = with licenses; [
      bsd2 # tix
      gpl2 # patches from portage
    ];
  };
}
