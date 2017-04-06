{ ghcjsBoot }: { callPackage }:

{
  async = callPackage
    ({ mkDerivation, base, HUnit, stm, test-framework
     , test-framework-hunit, stdenv
     }:
     mkDerivation {
       pname = "async";
       version = "2.1.1";
       src = "${ghcjsBoot}/boot/async";
       doCheck = false;
       libraryHaskellDepends = [ base stm ];
       testHaskellDepends = [
         base HUnit test-framework test-framework-hunit
       ];
       jailbreak = true;
       homepage = "https://github.com/simonmar/async";
       description = "Run IO operations asynchronously and wait for their results";
       license = stdenv.lib.licenses.bsd3;
     }) {};
  aeson = callPackage
    ({ mkDerivation, attoparsec, base, base-compat, base-orphans
     , base16-bytestring, bytestring, containers, deepseq, directory
     , dlist, fetchgit, filepath, generic-deriving, ghc-prim, hashable
     , hashable-time, HUnit, integer-logarithms, QuickCheck
     , quickcheck-instances, scientific, stdenv, tagged
     , template-haskell, test-framework, test-framework-hunit
     , test-framework-quickcheck2, text, time, time-locale-compat
     , unordered-containers, uuid-types, vector
     }:
     mkDerivation {
       pname = "aeson";
       version = "1.1.1.0";
       src = "${ghcjsBoot}/boot/aeson";
       libraryHaskellDepends = [
         attoparsec base base-compat bytestring containers deepseq dlist
         ghc-prim hashable scientific tagged template-haskell text time
         time-locale-compat unordered-containers uuid-types vector
       ];
       testHaskellDepends = [
         attoparsec base base-compat base-orphans base16-bytestring
         bytestring containers directory dlist filepath generic-deriving
         ghc-prim hashable hashable-time HUnit integer-logarithms QuickCheck
         quickcheck-instances scientific tagged template-haskell
         test-framework test-framework-hunit test-framework-quickcheck2 text
         time time-locale-compat unordered-containers uuid-types vector
       ];
       jailbreak = true;
       homepage = "https://github.com/bos/aeson";
       description = "Fast JSON parsing and encoding";
       license = stdenv.lib.licenses.bsd3;
     }) {};
  attoparsec = callPackage
    ({ mkDerivation, array, base, bytestring, case-insensitive
     , containers, criterion, deepseq, directory, filepath, ghc-prim
     , http-types, parsec, QuickCheck, quickcheck-unicode, scientific
     , tasty, tasty-quickcheck, text, transformers, unordered-containers
     , vector, stdenv
     }:
     mkDerivation {
       pname = "attoparsec";
       version = "0.13.1.0";
       src = "${ghcjsBoot}/boot/attoparsec";
       libraryHaskellDepends = [
         array base bytestring containers deepseq scientific text
         transformers
       ];
       testHaskellDepends = [
         array base bytestring deepseq QuickCheck quickcheck-unicode
         scientific tasty tasty-quickcheck text transformers vector
       ];
       benchmarkHaskellDepends = [
         array base bytestring case-insensitive containers criterion deepseq
         directory filepath ghc-prim http-types parsec scientific text
         transformers unordered-containers vector
       ];
       jailbreak = true;
       homepage = "https://github.com/bos/attoparsec";
       description = "Fast combinator parsing for bytestrings and text";
       license = stdenv.lib.licenses.bsd3;
     }) {};
  case-insensitive = callPackage
    ({ mkDerivation, base, bytestring, criterion, deepseq, hashable
     , HUnit, test-framework, test-framework-hunit, text, stdenv
     }:
     mkDerivation {
       pname = "case-insensitive";
       version = "1.2.0.8";
       src = "${ghcjsBoot}/boot/case-insensitive";
       doCheck = false;
       libraryHaskellDepends = [ base bytestring deepseq hashable text ];
       testHaskellDepends = [
         base bytestring HUnit test-framework test-framework-hunit text
       ];
       benchmarkHaskellDepends = [ base bytestring criterion deepseq ];
       jailbreak = true;
       homepage = "https://github.com/basvandijk/case-insensitive";
       description = "Case insensitive string comparison";
       license = stdenv.lib.licenses.bsd3;
     }) {};
  dlist = callPackage
    ({ mkDerivation, base, Cabal, deepseq, QuickCheck, stdenv }:
     mkDerivation {
       pname = "dlist";
       version = "0.8.0.2";
       src = "${ghcjsBoot}/boot/dlist";
       doCheck = false;
       libraryHaskellDepends = [ base deepseq ];
       testHaskellDepends = [ base Cabal QuickCheck ];
       jailbreak = true;
       homepage = "https://github.com/spl/dlist";
       description = "Difference lists";
       license = stdenv.lib.licenses.bsd3;
     }) {};
  extensible-exceptions = callPackage
    ({ mkDerivation, base, stdenv }:
      mkDerivation {
        pname = "extensible-exceptions";
        version = "0.1.1.4";
        src = "${ghcjsBoot}/boot/extensible-exceptions";
        doCheck = false;
        libraryHaskellDepends = [ base ];
        jailbreak = true;
        description = "Extensible exceptions";
        license = stdenv.lib.licenses.bsd3;
      }) {};
  hashable = callPackage
    ({ mkDerivation, base, bytestring, ghc-prim, HUnit, integer-gmp
      , QuickCheck, random, stdenv, test-framework, test-framework-hunit
      , test-framework-quickcheck2, text, unix
      }:
      mkDerivation {
        pname = "hashable";
        version = "1.2.4.0";
        src = "${ghcjsBoot}/boot/hashable";
        doCheck = false;
        libraryHaskellDepends = [
          base bytestring ghc-prim integer-gmp text
        ];
        testHaskellDepends = [
          base bytestring ghc-prim HUnit QuickCheck random test-framework
          test-framework-hunit test-framework-quickcheck2 text unix
        ];
        jailbreak = true;
        homepage = "http://github.com/tibbe/hashable";
        description = "A class for types that can be converted to a hash value";
        license = stdenv.lib.licenses.bsd3;
      }) {};
  mtl = callPackage
    ({ mkDerivation, base, stdenv, transformers }:
      mkDerivation {
        pname = "mtl";
        version = "2.2.2";
        src = "${ghcjsBoot}/boot/mtl";
        doCheck = false;
        libraryHaskellDepends = [ base transformers ];
        jailbreak = true;
        homepage = "http://github.com/ekmett/mtl";
        description = "Monad classes, using functional dependencies";
        license = stdenv.lib.licenses.bsd3;
      }) {};
  old-time = callPackage
    ({ mkDerivation, base, old-locale, stdenv }:
      mkDerivation {
        pname = "old-time";
        version = "1.1.0.3";
        src = "${ghcjsBoot}/boot/old-time";
        doCheck = false;
        libraryHaskellDepends = [ base old-locale ];
        jailbreak = true;
        description = "Time library";
        license = stdenv.lib.licenses.bsd3;
      }) {};
  parallel = callPackage
    ({ mkDerivation, array, base, containers, deepseq, stdenv }:
      mkDerivation {
        pname = "parallel";
        version = "3.2.1.0";
        src = "${ghcjsBoot}/boot/parallel";
        doCheck = false;
        libraryHaskellDepends = [ array base containers deepseq ];
        jailbreak = true;
        description = "Parallel programming library";
        license = stdenv.lib.licenses.bsd3;
      }) {};
  scientific = callPackage
    ({ mkDerivation, base, binary, bytestring, containers, criterion
     , deepseq, ghc-prim, hashable, integer-gmp, integer-logarithms
     , QuickCheck, smallcheck, tasty, tasty-ant-xml, tasty-hunit
     , tasty-quickcheck, tasty-smallcheck, text, vector, stdenv
     }:
     mkDerivation {
       pname = "scientific";
       version = "0.3.4.10";
       src = "${ghcjsBoot}/boot/scientific";
       libraryHaskellDepends = [
         base binary bytestring containers deepseq ghc-prim hashable
         integer-gmp integer-logarithms text vector
       ];
       testHaskellDepends = [
         base binary bytestring QuickCheck smallcheck tasty tasty-ant-xml
         tasty-hunit tasty-quickcheck tasty-smallcheck text
       ];
       benchmarkHaskellDepends = [ base criterion ];
       jailbreak = true;
       homepage = "https://github.com/basvandijk/scientific";
       description = "Numbers represented using scientific notation";
       license = stdenv.lib.licenses.bsd3;
     }) {};
  stm = callPackage
    ({ mkDerivation, array, base, stdenv }:
      mkDerivation {
        pname = "stm";
        version = "2.4.4.1";
        src = "${ghcjsBoot}/boot/stm";
        doCheck = false;
        libraryHaskellDepends = [ array base ];
        jailbreak = true;
        description = "Software Transactional Memory";
        license = stdenv.lib.licenses.bsd3;
      }) {};
  syb = callPackage
    ({ mkDerivation, base, containers, HUnit, mtl, stdenv }:
      mkDerivation {
        pname = "syb";
        version = "0.6";
        src = "${ghcjsBoot}/boot/syb";
        doCheck = false;
        libraryHaskellDepends = [ base ];
        testHaskellDepends = [ base containers HUnit mtl ];
        jailbreak = true;
        homepage = "http://www.cs.uu.nl/wiki/GenericProgramming/SYB";
        description = "Scrap Your Boilerplate";
        license = stdenv.lib.licenses.bsd3;
      }) {};
  tagged = callPackage
    ({ mkDerivation, base, deepseq, template-haskell, transformers
     , transformers-compat, stdenv
     }:
     mkDerivation {
       pname = "tagged";
       version = "0.8.5";
       src = "${ghcjsBoot}/boot/tagged";
       doCheck = false;
       libraryHaskellDepends = [
         base deepseq template-haskell transformers transformers-compat
       ];
       jailbreak = true;
       homepage = "http://github.com/ekmett/tagged";
       description = "Haskell 98 phantom types to avoid unsafely passing dummy arguments";
       license = stdenv.lib.licenses.bsd3;
     }) {};
  text = callPackage
    ({ mkDerivation, array, base, binary, bytestring, deepseq, directory
      , ghc-prim, HUnit, integer-gmp, QuickCheck, quickcheck-unicode
      , random, stdenv, test-framework, test-framework-hunit
      , test-framework-quickcheck2
      }:
      mkDerivation {
        pname = "text";
        version = "1.2.2.1";
        src = "${ghcjsBoot}/boot/text";
        doCheck = false;
        libraryHaskellDepends = [
          array base binary bytestring deepseq ghc-prim integer-gmp
        ];
        testHaskellDepends = [
          array base binary bytestring deepseq directory ghc-prim HUnit
          integer-gmp QuickCheck quickcheck-unicode random test-framework
          test-framework-hunit test-framework-quickcheck2
        ];
        jailbreak = true;
        homepage = "https://github.com/bos/text";
        description = "An efficient packed Unicode text type";
        license = stdenv.lib.licenses.bsd3;
      }) {};
  unordered-containers = callPackage
    ({ mkDerivation, base, bytestring, ChasingBottoms, containers
     , criterion, deepseq, deepseq-generics, hashable, hashmap, HUnit
     , mtl, QuickCheck, random, test-framework, test-framework-hunit
     , test-framework-quickcheck2, stdenv
     }:
     mkDerivation {
       pname = "unordered-containers";
       version = "0.2.7.2";
       src = "${ghcjsBoot}/boot/unordered-containers";
       libraryHaskellDepends = [ base deepseq hashable ];
       testHaskellDepends = [
         base ChasingBottoms containers hashable HUnit QuickCheck
         test-framework test-framework-hunit test-framework-quickcheck2
       ];
       benchmarkHaskellDepends = [
         base bytestring containers criterion deepseq deepseq-generics
         hashable hashmap mtl random
       ];
       jailbreak = true;
       homepage = "https://github.com/tibbe/unordered-containers";
       description = "Efficient hashing-based container types";
       license = stdenv.lib.licenses.bsd3;
     }) {};
  uuid-types = callPackage
    ({ mkDerivation, base, binary, bytestring, containers, criterion
     , deepseq, hashable, HUnit, QuickCheck, random, stdenv, tasty
     , tasty-hunit, tasty-quickcheck, text
     }:
     mkDerivation {
       pname = "uuid-types";
       version = "1.0.3";
       src = "${ghcjsBoot}/boot/uuid/uuid-types";
       libraryHaskellDepends = [
         base binary bytestring deepseq hashable random text
       ];
       testHaskellDepends = [
         base bytestring HUnit QuickCheck tasty tasty-hunit tasty-quickcheck
       ];
       benchmarkHaskellDepends = [
         base bytestring containers criterion deepseq random
       ];
       jailbreak = true;
       homepage = "https://github.com/aslatter/uuid";
       description = "Type definitions for Universally Unique Identifiers";
       license = stdenv.lib.licenses.bsd3;
     }) {};
  vector = callPackage
    ({ mkDerivation, base, deepseq, ghc-prim, primitive, QuickCheck
      , random, stdenv, template-haskell, test-framework
      , test-framework-quickcheck2, transformers
      }:
      mkDerivation {
        pname = "vector";
        version = "0.11.0.0";
        src = "${ghcjsBoot}/boot/vector";
        doCheck = false;
        libraryHaskellDepends = [ base deepseq ghc-prim primitive ];
        testHaskellDepends = [
          base QuickCheck random template-haskell test-framework
          test-framework-quickcheck2 transformers
        ];
        jailbreak = true;
        homepage = "https://github.com/haskell/vector";
        description = "Efficient Arrays";
        license = stdenv.lib.licenses.bsd3;
      }) {};
  ghcjs-base = callPackage
    ({ mkDerivation, aeson, array, attoparsec, base, bytestring
      , containers, deepseq, directory, dlist, ghc-prim, ghcjs-prim
      , hashable, HUnit, integer-gmp, primitive, QuickCheck
      , quickcheck-unicode, random, scientific, stdenv, test-framework
      , test-framework-hunit, test-framework-quickcheck2, text, time
      , transformers, unordered-containers, vector
      }:
      mkDerivation {
        pname = "ghcjs-base";
        version = "0.2.0.0";
        src = "${ghcjsBoot}/ghcjs/ghcjs-base";
        doCheck = false;
        libraryHaskellDepends = [
          aeson attoparsec base bytestring containers deepseq dlist ghc-prim
          ghcjs-prim hashable integer-gmp primitive scientific text time
          transformers unordered-containers vector
        ];
        testHaskellDepends = [
          array base bytestring deepseq directory ghc-prim ghcjs-prim HUnit
          primitive QuickCheck quickcheck-unicode random test-framework
          test-framework-hunit test-framework-quickcheck2 text
        ];
        jailbreak = true;
        homepage = "http://github.com/ghcjs/ghcjs-base";
        description = "Base library for GHCJS";
        license = stdenv.lib.licenses.mit;
      }) {};
  Cabal = callPackage
    ({ mkDerivation, array, base, binary, bytestring, containers
      , deepseq, directory, extensible-exceptions, filepath, HUnit
      , old-time, pretty, process, QuickCheck, regex-posix, stdenv
      , test-framework, test-framework-hunit, test-framework-quickcheck2
      , time, unix
      }:
      mkDerivation {
        pname = "Cabal";
        version = "1.24.0.0";
        src = "${ghcjsBoot}/boot/cabal/Cabal";
        doCheck = false;
        libraryHaskellDepends = [
          array base binary bytestring containers deepseq directory filepath
          pretty process time unix
        ];
        testHaskellDepends = [
          base bytestring containers directory extensible-exceptions filepath
          HUnit old-time process QuickCheck regex-posix test-framework
          test-framework-hunit test-framework-quickcheck2 unix
        ];
        jailbreak = true;
        homepage = "http://www.haskell.org/cabal/";
        description = "A framework for packaging Haskell software";
        license = stdenv.lib.licenses.bsd3;
      }) {};
}
