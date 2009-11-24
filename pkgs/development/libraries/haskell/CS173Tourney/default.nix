{cabal, fetchgit, json, time, hslogger, Crypto, base64string, CouchDB, WebServer, WebServerExtras}:

cabal.mkDerivation (self : {
  pname = "CS173Tourney";
  version = "2.5.2";
  
  src = fetchgit {
    url = git://github.com/arjunguha/173tourney.git;
    rev = "dce044761b008cb685a675a1f35be6aff66fed21" ;
    md5 = "21e5e5c2e184b4b70696d4d6c60e51d3";
  };
  patches = [./sendmail.patch]; 
  propagatedBuildInputs = [json time hslogger Crypto base64string CouchDB WebServer WebServerExtras];
  meta = {
    description = "";
  };
})  

