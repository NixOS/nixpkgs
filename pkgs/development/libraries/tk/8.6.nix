{ callPackage, fetchurl, tcl, lib, stdenv, ... } @ args:

callPackage ./generic.nix (args // {

  src = fetchurl {
    url = "mirror://sourceforge/tcl/tk${tcl.version}.1-src.tar.gz"; # TODO: remove '.1' for v8.6.10 or v8.7.x
    sha256 = "1gh9k7l76qg9l0sb78ijw9xz4xl1af47aqbdifb6mjpf3cbsnv00";
  };

  patches = [ ./different-prefix-with-tcl.patch ] ++ lib.optionals stdenv.isDarwin [ ./Fix-bad-install_name-for-libtk8.6.dylib.patch ];

})
