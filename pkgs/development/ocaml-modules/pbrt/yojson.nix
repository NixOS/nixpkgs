{
  buildDunePackage,
  pbrt,
  base64,
  yojson,
}:

buildDunePackage {
  pname = "pbrt_yojson";
  inherit (pbrt) version src;

  propagatedBuildInputs = [
    pbrt
    base64
    yojson
  ];

  meta = pbrt.meta // {
    description = "Runtime library for ocaml-protoc to support JSON encoding/decoding";
  };
}
