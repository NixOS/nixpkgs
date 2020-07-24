{ stdenv, fetchFromGitHub, buildDunePackage, base, cmdliner, ocaml_lwt,
  rdkafka, zlib }:

buildDunePackage rec {
  pname = "kafka";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "didier-wenzek";
    repo = "ocaml-kafka";
    rev = version;
    sha256 = "0lb8x0wh7sf8v9mjwhq32azjz54kw49fsjfb7m76z4nhxfkjw5hy";
  };

  buildInputs = [ base cmdliner ocaml_lwt zlib ];

  propagatedBuildInputs = [ rdkafka zlib ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/didier-wenzek/ocaml-kafka";
    description = "OCaml bindings for Kafka";
    license     = licenses.mit;
    maintainers = [ maintainers.rixed ];
  };
}

