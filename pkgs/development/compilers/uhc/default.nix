{ stdenv, coreutils, fetchgit, m4, libtool, clang, ghcWithPackages,
  shuffle,
  hashable, mtl, network, uhc-util, uulib
}:

let wrappedGhc = ghcWithPackages ( self: [hashable mtl network uhc-util uulib] );
in stdenv.mkDerivation rec {
  version = "1.1.8.7";
  name = "uhc-${version}";

  src = fetchgit {
    url = "https://github.com/UU-ComputerScience/uhc.git";
    rev = "0dec07e9cb60e78bbca63fc101f8fec6e249269f";
    sha256 = "0isz3qz23ihbn0rg54x8ddzwpsqlmmpkvaa66b7srfly7nciv8gl";
  };

  postUnpack = "sourceRoot=\${sourceRoot}/EHC";

  buildInputs = [ m4 wrappedGhc clang libtool shuffle ];

  configureFlags = [ "--with-gcc=${clang}/bin/clang" ];

  # UHC builds packages during compilation; these are by default
  # installed in the user-specific package config file. We do not
  # want that, and hack the build process to use a temporary package
  # configuration file instead.
  preConfigure = ''
    p=`pwd`/uhc-local-packages
    echo '[]' > $p
    sed -i "s|--user|--package-db=$p|g" mk/shared.mk.in
    sed -i "s|-fglasgow-exts|-fglasgow-exts -package-conf=$p|g" mk/shared.mk.in
    sed -i "s|/bin/date|${coreutils}/bin/date|g" mk/dist.mk
    sed -i "s|/bin/date|${coreutils}/bin/date|g" mk/config.mk.in
    sed -i "s|--make|--make -package-db=$p|g" src/ehc/files2.mk
    sed -i "s|--make|--make -package-db=$p|g" src/gen/files.mk
  '';

  inherit clang;

  meta = with stdenv.lib; {
    homepage = "http://www.cs.uu.nl/wiki/UHC";
    description = "Utrecht Haskell Compiler";
    maintainers = [ maintainers.phausmann ];
    platforms = stdenv.lib.platforms.unix;
  };
}
