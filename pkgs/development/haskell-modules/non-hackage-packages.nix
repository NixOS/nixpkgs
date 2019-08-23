# EXTRA HASKELL PACKAGES NOT ON HACKAGE
#
# This file should only contain packages that are not in ./hackage-packages.nix.
# Attributes in this set should be nothing more than a callPackage call.
# Overrides to these packages should go to either configuration-nix.nix,
# configuration-common.nix or to one of the compiler specific configuration
# files.
self: super: {

  multi-ghc-travis = throw ("haskellPackages.multi-ghc-travis has been renamed"
    + "to haskell-ci, which is now on hackage");

  # https://github.com/channable/vaultenv/issues/1
  vaultenv = self.callPackage ../tools/haskell/vaultenv { };

  cabal-install-3 = (self.callPackage
    ({ mkDerivation, array, async, base, base16-bytestring, binary
     , bytestring, Cabal, containers, cryptohash-sha256, deepseq
     , directory, echo, edit-distance, filepath, hackage-security
     , hashable, HTTP, mtl, network, network-uri, parsec, pretty
     , process, random, resolv, stdenv, stm, tar, text, time, unix, zlib
     , fetchFromGitHub
     }:
     mkDerivation {
       pname = "cabal-install";
       version = "3.0.0.0";
       src = fetchFromGitHub {
         owner = "haskell";
         repo = "cabal";
         rev = "b0e52fa173573705e861b129d9675e59de891e46";
         sha256 = "1fbph6crsn9ji8ps1k8dsxvgqn38rp4ffvv6nia1y7rbrdv90ass";
       };
       postUnpack = "sourceRoot+=/cabal-install";
       isLibrary = false;
       isExecutable = true;
       setupHaskellDepends = [ base Cabal filepath process ];
       executableHaskellDepends = [
         array async base base16-bytestring binary bytestring Cabal
         containers cryptohash-sha256 deepseq directory echo edit-distance
         filepath hackage-security hashable HTTP mtl network network-uri
         parsec pretty process random resolv stm tar text time unix zlib
       ];
       doCheck = false;
       postInstall = ''
         mkdir $out/etc
         mv bash-completion $out/etc/bash_completion.d
       '';
       homepage = "http://www.haskell.org/cabal/";
       description = "The command-line interface for Cabal and Hackage";
       license = stdenv.lib.licenses.bsd3;
     }) {}).overrideScope (self: super: {
       Cabal = self.Cabal_3_0_0_0;
     });

}
