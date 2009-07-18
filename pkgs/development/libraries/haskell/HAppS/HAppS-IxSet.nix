{cabal, mtl, hslogger, HAppSUtil, HAppSState, HAppSData, sybWithClass}:

cabal.mkDerivation (self : {
    pname = "HAppS-IxSet";
    version = "0.9.3";
    sha256 = "ebacd72e153bbcafb18bf4fa607550de98f8a991e9cfd8314b572cacf155a372";
    propagatedBuildInputs = [mtl hslogger HAppSUtil HAppSState HAppSData sybWithClass];
    meta = {
        longDescription = ''Web framework'';
        license = "free";
    };
})
