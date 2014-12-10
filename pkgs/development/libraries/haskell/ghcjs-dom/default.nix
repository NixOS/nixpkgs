{ cabal, fetchgit, ghc, mtl
, buildType ? if ghc.ghc.pname or null == "ghcjs" then "jsffi" else "webkit"
, ghcjsBase ? null # jsffi dependencies
, glib ? null, transformers ? null, gtk ? null, webkit ? null # webkit dependencies
}:

cabal.mkDerivation (self: {
  pname = "ghcjs-dom";
  version = "0.1.0.0";
  src = fetchgit {
    url = https://github.com/ghcjs/ghcjs-dom;
    rev = "15414daf6d7478eb98b66a6bff76607f875684a4";
    sha256 = "a1661eb3ad58c8214f75886fbeaa43b87bb3072c3abe087ad66832906a83e95a";
  };
  buildDepends = [ mtl ] ++ (if buildType == "jsffi" then [ ghcjsBase ] else if buildType == "webkit" then [ glib transformers gtk webkit ] else throw "unrecognized buildType");
  configureFlags = if buildType == "jsffi" then [ ] else if buildType == "webkit" then [ "-f-ghcjs" "-fwebkit" "-f-gtk3" ] else throw "unrecognized buildType";
  meta = {
    description = "DOM library that supports both GHCJS and WebKitGTK";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
