{ stdenv, targetPackages, gcc-prebuilt, component, hostPlatform, targetPlatform
, gmp, mpfr, libmpc, gcc, extraBuildInputs ? [] }:

with stdenv.lib;

let version = "7.3.0";
in stdenv.mkDerivation ({

  name = "gcc-${version}-${component}" + optionalString (targetPlatform != hostPlatform) "-${targetPlatform.config}";

  buildInputs = extraBuildInputs ++ [
    gcc-prebuilt
    gmp mpfr libmpc
    targetPackages.stdenv.cc.bintools
  ] ++ optional (component != "gcc") gcc;

  src = "${gcc-prebuilt}/prebuilt.tar.gz";
  # prebuilt doesn't have a root directory.
  setSourceRoot = "sourceRoot=`pwd`";

  postPatch = ''
    echo "rewriting prefix from ${gcc-prebuilt} -> $out"
    find . \( -name mkheaders\* -o -name Makefile \) -exec \
      sed -i -e "s|${gcc-prebuilt}|$out|g" {} \;
  '';

  # don't fail with: error: format string is not a string literal (potentially insecure) [-Werror,-Wformat-security]
  hardeningDisable = [ "format" ];
  enableParallelBuilding = true; # (component == "gcc"); #true;

  # We've already done the treewide configure
  # in the gcc-prebuilt.
  configurePhase = ''
    echo "configure disabled"
  '';
  dontStrip = true;

#  outputs = [ "out" "lib" "man" "info" ];
  makeFlags = [ "all-${component}" ];
  installTargets = "install-${component}";
#  postInstall = ''
#    ls -lah $out/
#  '';
} // optionalAttrs (component == "gcc") { buildPhase = ""; })
