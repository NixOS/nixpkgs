{cabal, mtl, hslogger, bytestring}:

cabal.mkDerivation (self : {
    pname = "HAppS-Util";
    version = "0.9.3";
    sha256 = "f9120d256e37111b6203dfc4eb598dd438c87e53bb9eb37258c999dd49b8e655";
    propagatedBuildInputs = [mtl hslogger bytestring];
    meta = {
        description = ''Web framework'';
        license = "free";
    };
})
