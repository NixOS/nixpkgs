{ cabal, c2hs, cudatoolkit, nvidia_x11 }:

cabal.mkDerivation (self: {
  pname = "cuda";
  version = "0.5.1.0";
  sha256 = "1zsfsz8i05iq54wxj1maj6qqzv4ibr459h47knc7ds1qv4giwzhl";
  buildTools = [ c2hs ];
  extraLibraries = [ cudatoolkit nvidia_x11 self.stdenv.gcc ];
  doCheck = false;
  # Perhaps this should be the default in cabal.nix ...
  #
  # The cudatoolkit provides both 64 and 32-bit versions of the
  # library. GHC's linker fails if the wrong version is found first.
  # We solve this by eliminating lib64 from the path on 32-bit
  # platforms and putting lib64 first on 64-bit platforms.
  libPaths = if self.stdenv.is64bit then "lib64 lib" else "lib";
  configurePhase = ''
    for i in Setup.hs Setup.lhs; do
      test -f $i && ghc --make $i
    done
    for p in $extraBuildInputs $propagatedNativeBuildInputs; do
      if [ -d "$p/include" ]; then
        extraLibDirs="$extraLibDirs --extra-include-dir=$p/include"
      fi
      for d in $libPaths; do
        if [ -d "$p/$d" ]; then
          extraLibDirs="$extraLibDirs --extra-lib-dir=$p/$d"
        fi
      done
    done
    ./Setup configure --verbose --prefix="$out" $libraryProfiling $extraLibDirs $configureFlags
  '';
  meta = {
    homepage = "https://github.com/tmcdonell/cuda";
    description = "FFI binding to the CUDA interface for programming NVIDIA GPUs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
