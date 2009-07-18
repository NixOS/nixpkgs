{cabal, HaXml, mtl, network, stm, hslogger, HAppSUtil, HAppSData, bytestring, binary, hspread}:

cabal.mkDerivation (self : {
    pname = "HAppS-State";
    version = "0.9.3";
    sha256 = "5099e635f8fcf56f775947a241a24e1aab6eb6d9fee0406e6a2169c4c8b331e4";
    propagatedBuildInputs = [HaXml mtl network stm hslogger HAppSUtil HAppSData bytestring binary hspread];
    meta = {
        description = ''Event-based distributed state.'';
        longDescription = ''Web framework'';
        license = "free";
    };
})
