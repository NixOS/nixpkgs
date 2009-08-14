{cabal, X11}:

cabal.mkDerivation (self : {
  pname = "HGL";
  version = "3.2.0.0";
  sha256 = "fa7cb1981f6e5a89b35e0fc2593c0945175a0d97fc3bc356cc8724fa1c881e86";
  propagatedBuildInputs = [X11];
  configureFlags = ''--constraint=base<4'';
  meta = {
    description = "A simple graphics library based on X11 or Win32";
  };
})

