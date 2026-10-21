{
  lib,
  fetchFromGitHub,
  buildDunePackage,
}:

buildDunePackage (finalAttrs: {
  pname = "pbrt";
  version = "4.1";

  src = fetchFromGitHub {
    owner = "mransan";
    repo = "ocaml-protoc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UrgrzI5Pgi79C/OhqYxwSNfqsoBULUZ13XVaB71fGes=";
  };

  meta = {
    homepage = "https://github.com/mransan/ocaml-protoc";
    description = "Runtime library for Protobuf tooling";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vyorkin ];
  };
})
