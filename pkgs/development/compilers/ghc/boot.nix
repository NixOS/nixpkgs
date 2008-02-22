{stdenv, fetchurl, perl, readline, ncurses, gmp}:

stdenv.mkDerivation {
  name = if stdenv.system == "i686-darwin" then "ghc-6.6.1" else "ghc-6.4.2";

  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        url = http://nix.cs.uu.nl/dist/tarballs/ghc-6.4.2-i386-unknown-linux.tar.bz2;
        md5 = "092fe2e25dab22b926babe97cc77db1f";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = http://haskell.org/ghc/dist/6.4.2/ghc-6.4.2-x86_64-unknown-linux.tar.bz2;
        md5 = "8f5fe48798f715cd05214a10987bf6d5";
      }
    else if stdenv.system == "i686-darwin" then
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
  postInstall = if stdenv.isDarwin then "

    ensureDir $out/frameworks/GMP.framework/Versions/A
    ln -s ${gmp}/lib/libgmp.dylib $out/frameworks/GMP.framework/GMP
    ln -s ${gmp}/lib/libgmp.dylib $out/frameworks/GMP.framework/Versions/A/GMP
    ensureDir $out/frameworks/GNUreadline.framework/Versions/A
    ln -s ${readline}/lib/libreadline.dylib $out/frameworks/GNUreadline.framework/GNUreadline
    ln -s ${readline}/lib/libreadline.dylib $out/frameworks/GNUreadline.framework/Versions/A/GNUreadline

    mv $out/bin $out/bin-orig
    mkdir $out/bin
    for i in $(cd $out/bin-orig && ls); do
        echo \"#! $SHELL -e\" >> $out/bin/$i
        echo \"DYLD_FRAMEWORK_PATH=$out/frameworks exec $out/bin-orig/$i -framework-path $out/frameworks \\\"\\$@\\\"\" >> $out/bin/$i
        chmod +x $out/bin/$i
    done

  " else "";

}
