{cabal, libX11, xineramaSupport ? true, libXinerama ? null, libXext ? null}:

assert xineramaSupport -> (libXinerama != null && libXext != null);

cabal.mkDerivation (self : {
  pname = "X11";
  version = "1.4.2";
  sha256 = "7a37ba1adee9c30a27013ea7058e907c2348ef08eaa79c9895e62e4f0d73d2aa";
  propagatedBuildInputs = [libX11] ++ (if xineramaSupport then [libXinerama libXext] else []);
  meta = {
    description = "A Haskell binding to the X11 graphics library";
  };
})
