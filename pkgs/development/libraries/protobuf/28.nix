{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "28.1";
    hash = "sha256-D1NjI6nujLnl4jnw9P2L3U+K58KCTOjLTmJhqTTcGuI=";
  }
  // args
)
