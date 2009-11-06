{cabal, fetchgit, Crypto, WebServer, base64string, hslogger, json, mtl
}:

cabal.mkDerivation (self : {
  pname = "WebServer-Extras";
  version = "1.2";
  
  src = fetchgit {
    url = git://github.com/arjunguha/haskell-web.git;
    rev = "76c9aabd31d03f052a80a0f6999dc7c5f1b11c41" ;
    sha256 = "afd550a4c6aeffe2f3adb38556b8e9ae198e98db17338ea6c8fa92d56c7eddb7";
  };
  sourceRoot = "git-export/Extras"; 
  propagatedBuildInputs = [Crypto WebServer base64string hslogger json mtl];
  meta = {
    description = "";
  };
})  

