{ mkDerivation, aeson, ansi-terminal, async, attoparsec, base
, base64-bytestring, bytestring, composition, constraints
, containers, cryptonite, data-default, deepseq, direct-sqlcipher
, directory, email-validate, exceptions, fetchgit, filepath
, generic-random, hspec, http-types, http2, lib, memory, mtl
, network, network-transport, optparse-applicative, process
, QuickCheck, random, record-hasfield, silently, simple-logger
, simplexmq, socks, sqlcipher-simple, stm, template-haskell
, terminal, text, time, tls, unliftio, unliftio-core, websockets
, zip
}:
mkDerivation {
  pname = "simplex-chat";
  version = "5.4.0.7";
  src = fetchgit {
    url = "https://github.com/simplex-chat/simplex-chat";
    sha256 = "sha256-ukzCoAsQBTO5xjun07Ysd070s3QL608DDSubvNKI5Zw=";
    rev = "2f7632a70f0d7904cb65f710bc6bc71edd44416e";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson ansi-terminal async attoparsec base base64-bytestring
    bytestring composition constraints containers cryptonite
    data-default direct-sqlcipher directory email-validate exceptions
    filepath http-types http2 memory mtl network network-transport
    optparse-applicative process random record-hasfield simple-logger
    simplexmq socks sqlcipher-simple stm template-haskell terminal text
    time tls unliftio unliftio-core zip
  ];
  executableHaskellDepends = [
    aeson ansi-terminal async attoparsec base base64-bytestring
    bytestring composition constraints containers cryptonite
    data-default direct-sqlcipher directory email-validate exceptions
    filepath http-types http2 memory mtl network network-transport
    optparse-applicative process random record-hasfield simple-logger
    simplexmq socks sqlcipher-simple stm template-haskell terminal text
    time tls unliftio unliftio-core websockets zip
  ];
  testHaskellDepends = [
    aeson ansi-terminal async attoparsec base base64-bytestring
    bytestring composition constraints containers cryptonite
    data-default deepseq direct-sqlcipher directory email-validate
    exceptions filepath generic-random hspec http-types http2 memory
    mtl network network-transport optparse-applicative process
    QuickCheck random record-hasfield silently simple-logger simplexmq
    socks sqlcipher-simple stm template-haskell terminal text time tls
    unliftio unliftio-core zip
  ];
  homepage = "https://github.com/simplex-chat/simplex-chat#readme";
  license = lib.licenses.agpl3Only;
}
