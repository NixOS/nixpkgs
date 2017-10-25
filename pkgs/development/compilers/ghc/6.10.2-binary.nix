{ stdenv
, fetchurl, perl
, libedit, ncurses5, gmp
}:

stdenv.mkDerivation rec {
  version = "6.10.2";

  name = "ghc-${version}-binary";

  src = fetchurl ({
    "i686-linux" = {
      # This binary requires libedit.so.0 (rather than libedit.so.2).
      url = "http://haskell.org/ghc/dist/${version}/ghc-${version}-i386-unknown-linux.tar.bz2";
      sha256 = "1fw0zr2qshlpk8s0d16k27zcv5263nqdg2xds5ymw8ff6qz9rz9b";
    };
    "x86_64-linux" = {
      # Idem.
      url = "http://haskell.org/ghc/dist/${version}/ghc-${version}-x86_64-unknown-linux.tar.bz2";
      sha256 = "1rd2j7lmcfsm2rdfb5g6q0l8dz3sxadk5m3d2f69d4a6g4p4h7jj";
    };
  }.${stdenv.hostPlatform.system}
    or (throw "cannot bootstrap GHC on this platform"));

  buildInputs = [perl];

  postUnpack =
    # Strip is harmful, see also below. It's important that this happens
    # first. The GHC Cabal build system makes use of strip by default and
    # has hardcoded paths to /usr/bin/strip in many places. We replace
    # those below, making them point to our dummy script.
    ''
      mkdir "$TMP/bin"
      for i in strip; do
        echo '#! ${stdenv.shell}' > "$TMP/bin/$i"
        chmod +x "$TMP/bin/$i"
      done
      PATH="$TMP/bin:$PATH"
    '' +
    # On Linux, use patchelf to modify the executables so that they can
    # find editline/gmp.
    stdenv.lib.optionalString stdenv.hostPlatform.isLinux ''
      find . -type f -perm -0100 \
          -exec patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          --set-rpath "${stdenv.lib.makeLibraryPath [ libedit ncurses5 gmp ]}" {} \;
      for prog in ld ar gcc strip ranlib; do
        find . -name "setup-config" -exec sed -i "s@/usr/bin/$prog@$(type -p $prog)@g" {} \;
      done
    '';

  configurePhase = ''
    ./configure --prefix=$out --with-gmp-libraries=${stdenv.lib.getLib gmp}/lib --with-gmp-includes=${stdenv.lib.getDev gmp}/include
  '';

  # Stripping combined with patchelf breaks the executables (they die
  # with a segfault or the kernel even refuses the execve). (NIXPKGS-85)
  dontStrip = true;

  # No building is necessary, but calling make without flags ironically
  # calls install-strip ...
  dontBuild = true;

  postInstall = ''
    # bah, the passing gmp doesn't work, so let's add it to the final package.conf in a quick but dirty way
    sed -i "s@^\(.*pkgName = PackageName \"rts\".*\libraryDirs = \\[\)\(.*\)@\\1\"${gmp.out}/lib\",\2@" $out/lib/ghc-${version}/package.conf

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

  meta = {
    homepage = http://haskell.org/ghc;
    description = "The Glasgow Haskell Compiler";
    license = stdenv.lib.licenses.bsd3;
    platforms = ["x86_64-linux" "i686-linux"];
  };

}
