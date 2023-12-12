{ lib, haskell, fetchFromGitHub }:

let
  name = "simplex-chat";
  compiler = "ghc96";
  hlib = haskell.lib;

  haskellOverrides = self: super: {
    direct-sqlcipher = self.callPackage ./simplex-chat/direct-sqlcipher.nix {};
    sqlcipher-simple = hlib.dontCheck (self.callPackage ./simplex-chat/sqlcipher-simple.nix {});
    simplexmq = hlib.dontCheck (hlib.doJailbreak (self.callPackage ./simplex-chat/simplexmq.nix {}));
    cryptostore = hlib.dontCheck super.cryptostore;
    aeson = hlib.dontCheck (self.callPackage ./simplex-chat/aeson.nix {});
    aeson-pretty = super.aeson-pretty_0_8_10;
    vector = hlib.doJailbreak super.vector;
    attoparsec-aeson = super.attoparsec-aeson_2_2_0_1;
    http2 = self.callPackage ./simplex-chat/http2.nix {};
    socks = self.callPackage ./simplex-chat/hs-socks.nix {};
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
