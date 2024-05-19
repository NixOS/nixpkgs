{ mkDerivation, aeson, base, bytestring, containers, cookie
, deepseq, exceptions, hashable, http-api-data, http-media, katip
, lens, lib, lifted-base, memory, monad-control, openapi3
, safe-exceptions, servant, servant-auth, servant-auth-swagger
, servant-openapi3, servant-swagger, servant-swagger-ui-core
, string-conv, swagger2, text, time, uuid
}:
mkDerivation {
  pname = "hercules-ci-api-core";
  version = "0.1.7.0";
  sha256 = "5383385f2d4207585e95a28bbac524947b13617d8b8da851e3733bd8c6552bd1";
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
