{ lib, haskell, fetchFromGitHub }:

let
  name = "simplex-chat";
  compiler = "ghc96";
  hlib = haskell.lib;

  haskellOverrides = self: super: {
    # original
    simplexmq = hlib.dontCheck (hlib.doJailbreak (self.callPackage ./simplex-chat/simplexmq.nix {}));

    # specific versions, already in the package set
    attoparsec-aeson = super.attoparsec-aeson_2_2_0_1;
    http2 = self.http2_4_2_2;
    aeson-pretty = super.aeson-pretty_0_8_10;

    # forks
    direct-sqlcipher = self.callPackage ./simplex-chat/direct-sqlcipher.nix {}; # https://github.com/IreneKnapp/direct-sqlite
    sqlcipher-simple = hlib.dontCheck (self.callPackage ./simplex-chat/sqlcipher-simple.nix {}); # https://github.com/nurpax/sqlite-simple
    aeson = self.callPackage ./simplex-chat/aeson.nix {}; # https://github.com/haskell/aeson
    socks = self.callPackage ./simplex-chat/hs-socks.nix {}; # https://github.com/vincenthz/hs-socks, unmaintained, archived by the original author

    simplex-chat = self.callPackage ./simplex-chat/simplex-chat.nix {};
  };

  hp = haskell.packages."${compiler}".extend haskellOverrides;

  meta = {
    mainProgram = "simplex-chat";
    homepage = "https://simplex.chat";
    description = "Command line version of SimpleX Chat.";
    license = lib.licenses.agpl3;
    maintainers = [ lib.maintainers.eyeinsky ];
    platforms = [ "x86_64-linux" ];
  };

in (hlib.dontCheck (hlib.doJailbreak hp.simplex-chat)) // { inherit meta; }
