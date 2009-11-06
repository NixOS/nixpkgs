{cabal, libX11, xineramaSupport ? true, libXinerama ? null, libXext ? null}:

assert xineramaSupport -> (libXinerama != null && libXext != null);

cabal.mkDerivation (self : {
  pname = "X11";
  version = "1.4.6.1";
  sha256 = "3e1375d4e53a8366fa2ea12bd9c3033ffe2f7dd00443acd84f722cf0dfff0fa9";
  propagatedBuildInputs = [libX11] ++ (if xineramaSupport then [libXinerama libXext] else []);
  meta = {
    description = "A Haskell binding to the X11 graphics library";
  };
})
