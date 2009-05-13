{fetchdarcs, cabal, mtl, parsec, readline, ivor, happy}:

cabal.mkDerivation (self : {
  pname = "idris";
  name = self.fname;
  version = "0.1.2";
  src = fetchdarcs {
    url = http://www-fp.dcs.st-and.ac.uk/~eb/darcs/Idris;
    sha256 = "de50ed4bedacee36d9942bf4db90deca3915cf6c106aa834d11e83972b2b639a";
    context = ./idris.context;
  };
  propagatedBuildInputs = [mtl parsec readline ivor];
  extraBuildInputs = [happy];
  preConfigure = ''
    echo "module Idris.Prefix where prefix = \"$out\"" > Idris/Prefix.hs
  '';
  postInstall = ''
    ensureDir $out/lib/idris
    install lib/*.idr lib/*.e $out/lib/idris
  '';
  meta = {
    description = "An experimental language with full dependent types";
  };
})
