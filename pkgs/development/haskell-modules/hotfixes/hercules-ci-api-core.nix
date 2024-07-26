{ mkDerivation, aeson, base, bytestring, containers, cookie
, deepseq, exceptions, hashable, http-api-data, http-media, katip
, lens, lib, lifted-base, memory, monad-control, openapi3
, safe-exceptions, servant, servant-auth, servant-auth-swagger
, servant-openapi3, servant-swagger, servant-swagger-ui-core
, string-conv, swagger2, text, time, uuid
}:
mkDerivation {
  pname = "hercules-ci-api-core";
  version = "0.1.6.0";
  sha256 = "0707c0792223993de583d42144a9e55fb510e6436a67d130d800df23457a1d93";
  libraryHaskellDepends = [
    aeson base bytestring containers cookie deepseq exceptions hashable
    http-api-data http-media katip lens lifted-base memory
    monad-control openapi3 safe-exceptions servant servant-auth
    servant-auth-swagger servant-openapi3 servant-swagger
    servant-swagger-ui-core string-conv swagger2 text time uuid
  ];
  homepage = "https://github.com/hercules-ci/hercules-ci-agent#readme";
  description = "Types and convenience modules use across Hercules CI API packages";
  license = lib.licenses.asl20;
}
