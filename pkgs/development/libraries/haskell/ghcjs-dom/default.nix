{ cabal, fetchgit, ghc, mtl
, buildType ? if (builtins.parseDrvName ghc.ghc.name).name == "ghcjs" then "jsffi" else "webkit"
, ghcjsBase ? null # jsffi dependencies
, glib ? null, transformers ? null, gtk ? null, webkit ? null # webkit dependencies
}:

cabal.mkDerivation (self: {
  pname = "ghcjs-dom";
  version = "0.1.0.0";
  src = fetchgit {
    url = https://github.com/ghcjs/ghcjs-dom;
    rev = "81805e75ccd41501774b90c04efd9e00d52e9798";
    sha256 = "3aa56fb81974533661aa056ed080edab29bef8ab26dae61999de4452f95949f6";
  };
  buildDepends = [ mtl ] ++ (if buildType == "jsffi" then [ ghcjsBase ] else if buildType == "webkit" then [ glib transformers gtk webkit ] else throw "unrecognized buildType");
  configureFlags = if buildType == "jsffi" then [ ] else if buildType == "webkit" then [ "-f-ghcjs" "-fwebkit" "-f-gtk3" ] else throw "unrecognized buildType";
  meta = {
    description = "DOM library that supports both GHCJS and WebKitGTK";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
