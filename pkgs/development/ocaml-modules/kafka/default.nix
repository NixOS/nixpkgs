{
  lib,
  fetchurl,
  ocaml,
  buildDunePackage,
  rdkafka,
  zlib,
}:

buildDunePackage (finalAttrs: {
  pname = "kafka";
  version = "0.5";

  src = fetchurl {
    url = "https://github.com/didier-wenzek/ocaml-kafka/releases/download/${finalAttrs.version}/kafka-${finalAttrs.version}.tbz";
    hash = "sha256-fsMmgcEEBipPrUPic24gYSjriCcxGAcaBECBq7wIIlU=";
  };

  propagatedBuildInputs = [
    rdkafka
    zlib
  ];

  meta = {
    homepage = "https://github.com/didier-wenzek/ocaml-kafka";
    description = "OCaml bindings for Kafka";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    broken = lib.versionAtLeast ocaml.version "5.0";
  };
})
