{stdenv, fetchurl, perl, readline, ncurses, gmp}:

let
  supportedPlatforms = ["i686-darwin" "x86_64-linux" "i686-linux"];
in

assert stdenv.lib.elem stdenv.system supportedPlatforms;

stdenv.mkDerivation {
  name = if stdenv.system == "i686-darwin" then "ghc-6.6.1-binary" else "ghc-6.4.2-binary";

  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        url = http://nixos.org/tarballs/ghc-6.4.2-i386-unknown-linux.tar.bz2;
        md5 = "092fe2e25dab22b926babe97cc77db1f";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = http://haskell.org/ghc/dist/6.4.2/ghc-6.4.2-x86_64-unknown-linux.tar.bz2;
        md5 = "8f5fe48798f715cd05214a10987bf6d5";
      }
    else if stdenv.system == "i686-darwin" then
      /* Yes, this isn't GHC 6.4.2.  But IIRC either there was no
         6.4.2 binary for Darwin, or it didn't work.  In any case, in
         Nixpkgs we just need this bootstrapping a "real" GHC. */
      fetchurl {
        url = http://www.haskell.org/ghc/dist/6.6.1/ghc-6.6.1-i386-apple-darwin.tar.bz2;
        sha256 = "1drbsicanr6jlykvs4vs6gbi2q9ac1bcaxz2vzwh3pfv3lfibwia";
      }
    else throw "cannot bootstrap GHC on this platform";

  buildInputs = [perl];

  # On Linux, use patchelf to modify the executables so that they can
  # find readline/gmp.
  postBuild = if stdenv.isLinux then "
    find . -type f -perm +100 \\
        -exec patchelf --interpreter \"$(cat $NIX_GCC/nix-support/dynamic-linker)\" \\
        --set-rpath \"${readline}/lib:${ncurses}/lib:${gmp}/lib\" {} \\;
  " else "";

  # Stripping combined with patchelf breaks the executables (they die
  # with a segfault or the kernel even refuses the execve). (NIXPKGS-85)
  dontStrip = true;

  # The binaries for Darwin use frameworks, so fake those frameworks,
  # and create some wrapper scripts that set DYLD_FRAMEWORK_PATH so
  # that the executables work with no special setup.
  postInstall = if stdenv.isDarwin then ''

    mkdir -p $out/frameworks/GMP.framework/Versions/A
    ln -s ${gmp}/lib/libgmp.dylib $out/frameworks/GMP.framework/GMP
    ln -s ${gmp}/lib/libgmp.dylib $out/frameworks/GMP.framework/Versions/A/GMP
    mkdir -p $out/frameworks/GNUreadline.framework/Versions/A
    ln -s ${readline}/lib/libreadline.dylib $out/frameworks/GNUreadline.framework/GNUreadline
    ln -s ${readline}/lib/libreadline.dylib $out/frameworks/GNUreadline.framework/Versions/A/GNUreadline

    mkdir $out/bin-orig
    for i in $(cd $out/bin && ls *); do
        mv $out/bin/$i $out/bin-orig/$i
        echo "#! $SHELL -e" >> $out/bin/$i
        extraFlag=
        if test $i != ghc-pkg; then extraFlag="-framework-path $out/frameworks"; fi
        echo "DYLD_FRAMEWORK_PATH=$out/frameworks exec $out/bin-orig/$i $extraFlag \"\$@\"" >> $out/bin/$i
        chmod +x $out/bin/$i
    done

  '' else "";

  meta.platforms = supportedPlatforms;
}
