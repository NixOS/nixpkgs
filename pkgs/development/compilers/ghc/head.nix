import ./common-hadrian.nix {
  version = "9.11.20240410";
  rev = "1b1a92bd25c3f7249cf922c5dbf4415d2de44a36";
  sha256 = "sha256-2HdhxhVrKn8c/ZOGYoYThqXpod2OPiGXgH+mAV69Ip0=";
  # The STM benchmark contains chanbench.hs and ChanBench.hs causing a hash
  # mismatch on case insensitive filesystems. See also
  # https://gitlab.haskell.org/ghc/packages/stm/-/issues/2
  postFetch = ''
    rm -rf "$out/libraries/stm/bench"
  '';
}
