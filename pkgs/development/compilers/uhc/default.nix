{ stdenv, coreutils, fetchgit, m4, libtool, clang, ghcWithPackages,
  shuffle,
  hashable, mtl, network, uhc-util, uulib
}:

let wrappedGhc = ghcWithPackages ( self: [hashable mtl network uhc-util uulib] );
in stdenv.mkDerivation rec {
  version = "1.1.8.10";
  name = "uhc-${version}";

  src = fetchgit {
    url = "https://github.com/UU-ComputerScience/uhc.git";
    rev = "449d9578e06af1362d7f746798f0aed57ab6ca88";
    sha256 = "0f8abhl9idbc2qlnb7ynrb11yvm3y07vksyzs1yg6snjvlhfj5az";
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

    # UHC i686 support is broken, see
    # https://github.com/UU-ComputerScience/uhc/issues/52
    #
    # Darwin build is broken as well at the moment.
    # On Darwin, the GNU libtool is used, which does not
    # support the -static flag and thus breaks the build.
    platforms = ["x86_64-linux"];
  };
}
