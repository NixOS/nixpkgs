{ mkDerivation, aeson, ansi-terminal, asn1-encoding, asn1-types
, async, attoparsec, base, base64-bytestring, bytestring
, case-insensitive, composition, constraints, containers
, cryptonite, cryptostore, data-default, deepseq, direct-sqlcipher
, directory, fetchgit, filepath, generic-random, hourglass, hspec
, hspec-core, http-types, http2, HUnit, ini, iproute, iso8601-time
, lib, main-tester, memory, mtl, network, network-info
, network-transport, network-udp, openssl, optparse-applicative
, process, QuickCheck, random, silently, simple-logger, socks
, sqlcipher-simple, stm, template-haskell, temporary, text, time
, time-compat, time-manager, timeit, tls, transformers, unliftio
, unliftio-core, websockets, x509, x509-store, x509-validation
, yaml
}:
mkDerivation {
  pname = "simplexmq";
  version = "5.4.0.7";
  src = fetchgit {
    url = "https://github.com/simplex-chat/simplexmq";
    sha256 = "sha256-ITV4oJfgif9K8P+bLGlxdf0tu9F3X48a4hXe/wu0PJs=";
    rev = "a860936072172e261480fa6bdd95203976e366b2";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson ansi-terminal asn1-encoding asn1-types async attoparsec base
    base64-bytestring bytestring case-insensitive composition
    constraints containers cryptonite cryptostore data-default
    direct-sqlcipher directory filepath hourglass http-types http2 ini
    iproute iso8601-time memory mtl network network-info
    network-transport network-udp optparse-applicative process random
    simple-logger socks sqlcipher-simple stm template-haskell temporary
    text time time-compat time-manager tls transformers unliftio
    unliftio-core websockets x509 x509-store x509-validation yaml
  ];
  librarySystemDepends = [ openssl ];
  executableHaskellDepends = [
    aeson ansi-terminal asn1-encoding asn1-types async attoparsec base
    base64-bytestring bytestring case-insensitive composition
    constraints containers cryptonite cryptostore data-default
    direct-sqlcipher directory filepath hourglass http-types http2 ini
    iproute iso8601-time memory mtl network network-info
    network-transport network-udp optparse-applicative process random
    simple-logger socks sqlcipher-simple stm template-haskell temporary
    text time time-compat time-manager tls transformers unliftio
    unliftio-core websockets x509 x509-store x509-validation yaml
  ];
  testHaskellDepends = [
    aeson ansi-terminal asn1-encoding asn1-types async attoparsec base
    base64-bytestring bytestring case-insensitive composition
    constraints containers cryptonite cryptostore data-default deepseq
    direct-sqlcipher directory filepath generic-random hourglass hspec
    hspec-core http-types http2 HUnit ini iproute iso8601-time
    main-tester memory mtl network network-info network-transport
    network-udp optparse-applicative process QuickCheck random silently
    simple-logger socks sqlcipher-simple stm template-haskell temporary
    text time time-compat time-manager timeit tls transformers unliftio
    unliftio-core websockets x509 x509-store x509-validation yaml
  ];
  homepage = "https://github.com/simplex-chat/simplexmq#readme";
  description = "SimpleXMQ message broker";
  license = lib.licenses.agpl3Only;
}
