{stdenv, fetchurl, perl, editline, ncurses, gmp, makeWrapper}:

stdenv.mkDerivation rec {
  version = "6.10.1";

  name = "ghc-${version}";

  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        # libedit .so.0
        url = "http://haskell.org/ghc/dist/${version}/ghc-${version}-i386-unknown-linux.tar.bz2";
        sha256 = "18l0vwlf7y86s65klpdvz4ccp8kydvcmyh03c86hld8jvx16q7zz";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        # libedit .so.0
        url = "http://haskell.org/ghc/dist/${version}/ghc-${version}-x86_64-unknown-linux.tar.bz2";
        sha256 = "14jvvn333i36wm7mmvi47jr93f5hxrw1h2dpjvqql0rp00svhzzg";
      }
    else if stdenv.system == "i686-darwin" then
      fetchurl {
        # update
        # untested
      }
    else throw "cannot bootstrap GHC on this platform"; 

  buildInputs = [perl makeWrapper];

  # On Linux, use patchelf to modify the executables so that they can
  # find editline/gmp.
  postUnpack = (if stdenv.isLinux then ''
    find . -type f -perm +100 \
        -exec patchelf --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
        --set-rpath "${editline}/lib:${ncurses}/lib:${gmp}/lib" {} \;
    for prog in strip ranlib; do
      find . -name "setup-config" -exec sed -i "s@/usr/bin/$prog@$(type -p $prog)@g" {} \;
    done
  '' else "")
  + ''
    mkdir "$TMP/bin"
    for i in strip; do
      echo '#!/bin/sh' >> "$TMP/bin/$i"
      chmod +x "$TMP/bin/$i"
      PATH="$TMP/bin:$PATH"
    done
  ''
  
  ;

  configurePhase = ''
    ./configure --prefix=$out --with-gmp-libraries=${gmp}/lib --with-gmp-includes=${gmp}/include
  '';
  # Stripping combined with patchelf breaks the executables (they die
  # with a segfault or the kernel even refuses the execve). (NIXPKGS-85)
  dontStrip = true;

  # The binaries for Darwin use frameworks, so fake those frameworks,
  # and create some wrapper scripts that set DYLD_FRAMEWORK_PATH so
  # that the executables work with no special setup.
  postInstall = (if stdenv.isDarwin then "

    ensureDir $out/frameworks/GMP.framework/Versions/A
    ln -s ${gmp}/lib/libgmp.dylib $out/frameworks/GMP.framework/GMP
    ln -s ${gmp}/lib/libgmp.dylib $out/frameworks/GMP.framework/Versions/A/GMP
    ensureDir $out/frameworks/GNUeditline.framework/Versions/A
    ln -s ${editline}/lib/libeditline.dylib $out/frameworks/GNUeditline.framework/GNUeditline
    ln -s ${editline}/lib/libeditline.dylib $out/frameworks/GNUeditline.framework/Versions/A/GNUeditline

    mv $out/bin $out/bin-orig
    mkdir $out/bin
    for i in $(cd $out/bin-orig && ls); do
        echo \"#! $SHELL -e\" >> $out/bin/$i
        echo \"DYLD_FRAMEWORK_PATH=$out/frameworks exec $out/bin-orig/$i -framework-path $out/frameworks \\\"\\$@\\\"\" >> $out/bin/$i
        chmod +x $out/bin/$i
    done

  " else "")
  +
  ''
  # the installed ghc executable segfaults, maybe some stripping or such has been done somewhere?
  # Just copy teh version from the $TMP dir over
  cp ghc/dist-stage2/build/ghc/ghc $out/lib/ghc-${version}/ghc
  # bah, the passing gmp doesn't work, so let's add it to the final package.conf in a quick but dirty way
  sed -i "s@^\(.*pkgName = PackageName \"rts\".*\libraryDirs = \\[\)\(.*\)@\\1\"${gmp}/lib\",\2@" $out/lib/ghc-${version}/package.conf

  wrapProgram $out/bin/ghc --set LDPATH "${gmp}/lib"
  # sanity check, can ghc create executables?
  cd $TMP
  mkdir test-ghc; cd test-ghc
  cat > main.hs << EOF
  module Main where
  main = putStrLn "yes"
  EOF
  $out/bin/ghc --make main.hs
  echo compilation ok
  [ $(./main) == "yes" ]
  ''
  ;

}
