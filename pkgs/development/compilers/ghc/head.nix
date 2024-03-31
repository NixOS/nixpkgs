import ./common-hadrian.nix {
  version = "9.11.20240323";
  rev = "8f7cfc7ee00978fda14f31ce4a56ad4639c07138";
  sha256 = "sha256-UFiZ8Vu45PZ1+QuyoruiXA6ksiFZImQvvsgC3kQCHak=";
  # The STM benchmark contains chanbench.hs and ChanBench.hs causing a hash
  # mismatch on case insensitive filesystems. See also
  # https://gitlab.haskell.org/ghc/packages/stm/-/issues/2
  postFetch = ''
    rm -rf "$out/libraries/stm/bench"
  '';
}
