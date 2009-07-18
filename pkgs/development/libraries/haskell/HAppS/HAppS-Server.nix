{cabal, HaXml, parsec, mtl, network, hslogger, HAppSData, HAppSUtil, HAppSState, HAppSIxSet, HTTP, xhtml, html, bytestring}:

cabal.mkDerivation (self : {
    pname = "HAppS-Server";
    version = "0.9.3.1";
    sha256 = "b03129f332c35cd558b0f32bc626321dcfa2647dd7ddf67f3403eca8c4c52038";
    propagatedBuildInputs = [HaXml parsec mtl network hslogger HAppSData HAppSUtil HAppSState HAppSIxSet HTTP xhtml html bytestring];
    meta = {
        description = ''Web related tools and services.'';
        longDescription = ''Web framework'';
        license = "free";
    };
})
