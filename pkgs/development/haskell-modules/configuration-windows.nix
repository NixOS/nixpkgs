{ pkgs, haskellLib }:

let
  inherit (pkgs) fetchpatch lib;
in

with haskellLib;

(self: super: {
  # cabal2nix doesn't properly add dependencies conditional on os(windows)
  digest = addBuildDepends [ self.zlib ] super.digest;
  echo = addBuildDepends [ self.mintty ] super.echo;
  http-client = addBuildDepends [ self.safe ] super.http-client;
  regex-posix = addBuildDepends [ self.regex-posix-clib ] super.regex-posix;
  simple-sendfile =
    with self;
    addBuildDepends [ conduit conduit-extra resourcet ] super.simple-sendfile;
  snap-core = addBuildDepends [ self.time-locale-compat ] super.snap-core;
  tar-conduit = addBuildDepends [ self.unix-compat ] super.tar-conduit;
  unix-time = addBuildDepends [ pkgs.windows.pthreads ] super.unix-time;
  warp = addBuildDepends [ self.unix-compat ] super.warp;

  network = lib.pipe super.network [
    (addBuildDepends [ self.temporary ])

    # https://github.com/haskell/network/pull/605
    (appendPatch (fetchpatch {
      name = "dont-frag-wine.patch";
      url = "https://github.com/haskell/network/commit/ecd94408696117d34d4c13031c30d18033504827.patch";
      sha256 = "sha256-8LtAkBmgMMMIW6gPYDVuwYck/4fcOf08Hp2zLmsRW2w=";
    }))
  ];
})
