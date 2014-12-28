{ cabal, fetchgit, ghc, mtl
, buildType ? if ghc.ghc.pname or null == "ghcjs" then "jsffi" else "webkit"
, ghcjsBase ? null # jsffi dependencies
, glib ? null, transformers ? null, gtk ? null, webkit ? null # webkit dependencies
}:

cabal.mkDerivation (self: {
  pname = "ghcjs-dom";
  version = "0.1.1.3";
  sha256 = "0pdxb2s7fflrh8sbqakv0qi13jkn3d0yc32xhg2944yfjg5fvlly";
  buildDepends = [ mtl ] ++ (if buildType == "jsffi" then [ ghcjsBase ] else if buildType == "webkit" then [ glib transformers gtk webkit ] else throw "unrecognized buildType");
  configureFlags = if buildType == "jsffi" then [ ] else if buildType == "webkit" then [ "-f-ghcjs" "-fwebkit" "-f-gtk3" ] else throw "unrecognized buildType";
  meta = {
    description = "DOM library that supports both GHCJS and WebKitGTK";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
