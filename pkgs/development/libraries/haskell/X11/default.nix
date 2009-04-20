{cabal, libX11, xineramaSupport ? true, libXinerama ? null, libXext ? null}:

assert xineramaSupport -> (libXinerama != null && libXext != null);

cabal.mkDerivation (self : {
  pname = "X11";
  version = "1.4.5";
  sha256 = "6665056b9fe5801ca27bf960a90215c940ae70b549753efed0303d5ed8d89ddb";
  propagatedBuildInputs = [libX11] ++ (if xineramaSupport then [libXinerama libXext] else []);
  meta = {
    description = "A Haskell binding to the X11 graphics library";
  };
})
