{
  buildDunePackage,
  pbrt,
  pbrt_yojson,
}:

buildDunePackage {
  pname = "pbrt_services";
  inherit (pbrt) version src;

  propagatedBuildInputs = [
    pbrt
    pbrt_yojson
  ];

  meta = pbrt.meta // {
    description = "Runtime library for ocaml-protoc to support RPC services";
  };
}
