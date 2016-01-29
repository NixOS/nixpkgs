# Note: The Haskell package set used for building UHC is
# determined in the file top-level/haskell-packages.nix.
# We are using Stackage LTS to avoid constant breakage.
# Bump the Stackage LTS release to the last release if possible
# when a new UHC version is released.
{ stdenv, coreutils, fetchgit, m4, libtool, clang, ghcWithPackages }:

let wrappedGhc = ghcWithPackages (hpkgs: with hpkgs; [fgl vector syb uulib network binary hashable uhc-util mtl transformers directory containers array process filepath shuffle uuagc] );
in stdenv.mkDerivation rec {
  # Important:
  # The commits "Fixate/tag v..." are the released versions.
  # Ignore the "bumped version to ...." commits, they do not
  # correspond to releases.
  version = "1.1.9.2";
  name = "uhc-${version}";

  src = fetchgit {
    url = "https://github.com/UU-ComputerScience/uhc.git";
    rev = "292d259113b98c32154a5be336875751caa5edbc";
    sha256 = "1f462xq9ilkp9mnxm8hxhh1cdwps5d0hxysyibxryk32l7hh53cz";
  };

  postUnpack = "sourceRoot=\${sourceRoot}/EHC";

  buildInputs = [ m4 wrappedGhc clang libtool ];

  configureFlags = [ "--with-gcc=${clang}/bin/clang" ];

  # UHC builds packages during compilation; these are by default
  # installed in the user-specific package config file. We do not
  # want that, and hack the build process to use a temporary package
  # configuration file instead.
  preConfigure = ''
    p=`pwd`/uhc-local-packages/
    ghc-pkg init $p
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
    maintainers = [ maintainers.phile314 ];

    # UHC i686 support is broken, see
    # https://github.com/UU-ComputerScience/uhc/issues/52
    #
    # Darwin build is broken as well at the moment.
    # On Darwin, the GNU libtool is used, which does not
    # support the -static flag and thus breaks the build.
    platforms = ["x86_64-linux"];
    # Hydra currently doesn't build the Stackage LTS package set,
    # and we don't want to build all our haskell dependencies
    # from scratch just to build UHC.
    hydraPlatforms = stdenv.lib.platforms.none;

  };
}
