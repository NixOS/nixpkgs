{stdenv, fetchurl, perl, libedit, ncurses, gmp}:

stdenv.mkDerivation rec {
  version = "6.10.1";

  name = "ghc-${version}-binary";

  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        # This binary requires libedit.so.0 (rather than libedit.so.2).
        url = "http://haskell.org/ghc/dist/${version}/ghc-${version}-i386-unknown-linux.tar.bz2";
        sha256 = "18l0vwlf7y86s65klpdvz4ccp8kydvcmyh03c86hld8jvx16q7zz";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        # Idem.
        url = "http://haskell.org/ghc/dist/${version}/ghc-${version}-x86_64-unknown-linux.tar.bz2";
        sha256 = "14jvvn333i36wm7mmvi47jr93f5hxrw1h2dpjvqql0rp00svhzzg";
      }
    else if stdenv.system == "i686-darwin" then
      fetchurl {
        # Idem.
        url = "http://haskell.org/ghc/dist/${version}/maeder/ghc-${version}-i386-apple-darwin.tar.bz2";
        sha256 = "0lax61cfzxkrjb7an3magdax6c8fygsirpw9qfmc651k2sfby1mq";
      }
    else throw "cannot bootstrap GHC on this platform";

  buildInputs = [perl];

  postUnpack =
    # Strip is harmful, see also below. It's important that this happens
    # first. The GHC Cabal build system makes use of strip by default and
    # has hardcoded paths to /usr/bin/strip in many places. We replace
    # those below, making them point to our dummy script.
     ''
      mkdir "$TMP/bin"
      for i in strip; do
        echo '#!/bin/sh' >> "$TMP/bin/$i"
        chmod +x "$TMP/bin/$i"
        PATH="$TMP/bin:$PATH"
      done
     '' +
    # On Linux, use patchelf to modify the executables so that they can
    # find editline/gmp.
    (if stdenv.isLinux then ''
      find . -type f -perm +100 \
          -exec patchelf --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
          --set-rpath "${libedit}/lib:${ncurses}/lib:${gmp}/lib" {} \;
      for prog in ld ar gcc strip ranlib; do
        find . -name "setup-config" -exec sed -i "s@/usr/bin/$prog@$(type -p $prog)@g" {} \;
      done
     '' else "");

  configurePhase = ''
    ${if stdenv.isDarwin then "export DYLD_LIBRARY_PATH=${gmp}/lib" else ""}
    cp $(type -P pwd) utils/pwd/pwd
    ./configure --prefix=$out --with-gmp-libraries=${gmp}/lib --with-gmp-includes=${gmp}/include
  '';

  # Stripping combined with patchelf breaks the executables (they die
  # with a segfault or the kernel even refuses the execve). (NIXPKGS-85)
  dontStrip = true;

  # No building is necessary, but calling make without flags ironically
  # calls install-strip ...
  buildPhase = "true";

  # The binaries for Darwin use frameworks, so fake those frameworks,
  # and create some wrapper scripts that set DYLD_FRAMEWORK_PATH so
  # that the executables work with no special setup.
  postInstall =
    (if stdenv.isDarwin then
      ''
        mv $out/bin $out/bin-orig
        mkdir $out/bin
        for i in $(cd $out/bin-orig && ls); do
            echo "#! $SHELL -e" >> $out/bin/$i
            echo "export DYLD_LIBRARY_PATH=\"${gmp}/lib:${libedit}/lib\"" >> $out/bin/$i
            echo "exec $out/bin-orig/$i \"\$@\"" >> $out/bin/$i
            chmod +x $out/bin/$i
        done
      '' else "")
    +
      ''
        # bah, the passing gmp doesn't work, so let's add it to the final package.conf in a quick but dirty way
        sed -i "s@^\(.*pkgName = PackageName \"rts\".*\libraryDirs = \\[\)\(.*\)@\\1\"${gmp}/lib\",\2@" $out/lib/ghc-${version}/package.conf

        # Sanity check, can ghc create executables?
        cd $TMP
        mkdir test-ghc; cd test-ghc
        cat > main.hs << EOF
          module Main where
          main = putStrLn "yes"
        EOF
        $out/bin/ghc --make main.hs
        echo compilation ok
        [ $(./main) == "yes" ]
      '';

}
