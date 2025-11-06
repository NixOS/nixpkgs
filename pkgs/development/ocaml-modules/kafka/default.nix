{
  lib,
  fetchurl,
  ocaml,
  buildDunePackage,
  rdkafka,
  zlib,
}:

lib.throwIf (lib.versionAtLeast ocaml.version "5.0")
  "kafka is not available for OCaml ${ocaml.version}"

  buildDunePackage
  rec {
    pname = "kafka";
    version = "0.5";

    src = fetchurl {
      url = "https://github.com/didier-wenzek/ocaml-kafka/releases/download/${version}/kafka-${version}.tbz";
      sha256 = "0m9212yap0a00hd0f61i4y4fna3141p77qj3mm7jl1h4q60jdhvy";
    };

    propagatedBuildInputs = [
      rdkafka
      zlib
    ];

    meta = with lib; {
      homepage = "https://github.com/didier-wenzek/ocaml-kafka";
      description = "OCaml bindings for Kafka";
      license = licenses.mit;
      maintainers = [ maintainers.vbgl ];
    };
  }
