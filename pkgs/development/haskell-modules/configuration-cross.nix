{ pkgs, haskellLib }:

let
  inherit (pkgs) lib;
in

with haskellLib;

self: super: {
  # Avoids a cycle by disabling use of the external interpreter by the packages that are dependencies of iserv-proxy
  # These in particular can't rely on template haskell for cross-compilation anyway as they can't rely on iserv-proxy
  inherit
    (
      let
        noExternalInterpreter = overrideCabal {
          enableExternalInterpreter = false;
        };
      in
      lib.mapAttrs (_: noExternalInterpreter) { inherit (super) iserv-proxy libiserv network; }
    )
    iserv-proxy
    libiserv
    network
    ;

  # qemu: uncaught target signal 4 (Illegal instruction) - core dumped
  th-expand-syns = dontCheck super.th-expand-syns;

  # test/Unicode/CharSpec.hs:206:21:
  # 1) Unicode.Char.Case toUpper
  #      predicate failed on: '\411'
  unicode-data = dontCheck super.unicode-data;

  # syntax error: unexpected word (expecting ")")
  jsaddle-warp = dontCheck super.jsaddle-warp;

  # test-pandoc: line 0: syntax error: unterminated quoted string
  pandoc = dontCheck super.pandoc;

  # Tests take a long time or maybe hang
  bitvec = dontCheck super.bitvec;
  crypton = dontCheck super.crypton;
  crypton-x509-validation = dontCheck super.crypton-x509-validation;
  tls = dontCheck super.tls;

  # Test suite rootCleanup: FAIL
  reflex = dontCheck super.reflex;

  # Couldn't find a target code interpreter. Try with -fexternal-interpreter
  bsb-http-chunked = dontCheck super.bsb-http-chunked;
  doctest-parallel = dontCheck super.doctest-parallel;
  foldl = dontCheck super.foldl;

  # https://gitlab.haskell.org/ghc/ghc/-/issues/14335
  # <no location info>: error: Plugins require -fno-external-interpreter
  infer-license = dontCheck super.infer-license;
  inspection-testing = dontCheck super.inspection-testing;
  large-records = dontCheck super.large-records;
  vector = dontCheck super.vector;

  # could not execute: hspec-discover
  here = dontCheck super.here;
  hspec-wai = dontCheck super.hspec-wai;
  http-date = dontCheck super.http-date;
  http-types = dontCheck super.http-types;
  unliftio = dontCheck super.unliftio;
  word8 = dontCheck super.word8;
  yaml = dontCheck super.yaml;

  # posix_spawnp: invalid argument (Exec format error)
  file-lock = dontCheck super.file-lock;
  safe-exceptions = dontCheck super.safe-exceptions;
  warp = dontCheck super.warp;
  zip-archive = dontCheck super.zip-archive;

  # Mmap.hsc: In function ‘_hsc2hs_test13’:
  # Mmap.hsc:54:20: error: storage size of ‘test_array’ isn’t constant
  hashable = dontCheck super.hashable;

  # hGetLine: end of file
  doctest = dontCheck super.doctest;
  xml-conduit = dontCheck super.xml-conduit;
}
