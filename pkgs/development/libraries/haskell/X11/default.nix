{cabal, libX11, xineramaSupport ? true, libXinerama ? null, libXext ? null}:

assert xineramaSupport -> (libXinerama != null && libXext != null);

cabal.mkDerivation (self : {
  pname = "X11";
  version = "1.4.1";
  sha256 = "e51038541415686f0e278ccdbc0b2373cd11f212de99023b7b8f8e776aa09f79";
  propagatedBuildInputs = [libX11] ++ (if xineramaSupport then [libXinerama libXext] else []);
  meta = {
    description = "A Haskell binding to the X11 graphics library";
  };
})
