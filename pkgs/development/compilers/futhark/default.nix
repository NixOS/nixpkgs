# Generated using `cabal2nix --hpack .`, then replace src
{ mkDerivation, alex, array, base, bifunctors, binary, blaze-html
, bytestring, containers, data-binary-ieee754, directory
, directory-tree, dlist, extra, file-embed, filepath, gitrev, happy
, haskeline, hpack, HUnit, json, language-c-quote, mainland-pretty
, markdown, mtl, neat-interpolation, parallel, parsec, process
, process-extras, QuickCheck, random, raw-strings-qq, regex-tdfa
, srcloc, stdenv, template-haskell, temporary, test-framework
, test-framework-hunit, test-framework-quickcheck2, text
, th-lift-instances, transformers, vector, vector-binary-instances
, zlib, fetchFromGitHub
}:
mkDerivation {
  pname = "futhark";
  version = "0.6.2";
  src = fetchFromGitHub {
    owner = "diku-dk";
    repo = "futhark";
    rev = "v0.6.2";
    sha256 = "0yj7n01swpvqblybdnks3mjf0mzf1gdg2b2cpxdpxnrjw5j0pnq2";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    array base bifunctors binary blaze-html bytestring containers
    data-binary-ieee754 directory directory-tree dlist extra file-embed
    filepath gitrev language-c-quote mainland-pretty markdown mtl
    neat-interpolation parallel parsec process raw-strings-qq
    regex-tdfa srcloc template-haskell text th-lift-instances
    transformers vector vector-binary-instances zlib
  ];
  libraryToolDepends = [ alex happy hpack ];
  executableHaskellDepends = [
    array base bifunctors binary blaze-html bytestring containers
    data-binary-ieee754 directory directory-tree dlist extra file-embed
    filepath gitrev haskeline json language-c-quote mainland-pretty
    markdown mtl neat-interpolation parallel parsec process
    process-extras random raw-strings-qq regex-tdfa srcloc
    template-haskell temporary text th-lift-instances transformers
    vector vector-binary-instances zlib
  ];
  testHaskellDepends = [
    array base bifunctors binary blaze-html bytestring containers
    data-binary-ieee754 directory directory-tree dlist extra file-embed
    filepath gitrev HUnit language-c-quote mainland-pretty markdown mtl
    neat-interpolation parallel parsec process QuickCheck
    raw-strings-qq regex-tdfa srcloc template-haskell test-framework
    test-framework-hunit test-framework-quickcheck2 text
    th-lift-instances transformers vector vector-binary-instances zlib
  ];
  preConfigure = "hpack";
  homepage = "https://futhark-lang.org";
  description = "An optimising compiler for a functional, array-oriented language";
  license = stdenv.lib.licenses.isc;
}
