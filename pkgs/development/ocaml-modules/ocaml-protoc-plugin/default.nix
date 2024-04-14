{ lib
, fetchFromGitHub
, buildDunePackage
, pkg-config
, protobuf
, zarith
, ppx_deriving
, ppx_deriving_yojson
, re
, dune-site
, ppx_expect
}:

buildDunePackage rec {
  pname = "ocaml-protoc-plugin";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "issuu";
    repo = "ocaml-protoc-plugin";
    rev = version;
    hash = "sha256-ZHeOi3y2X11MmkRuthmYFSjPLoGlGTO1pnRfk/XmgPU=";
  };

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];
  buildInputs = [
    zarith
    ppx_deriving
    ppx_deriving_yojson
    re
    dune-site
    ppx_expect
    protobuf
  ];
  doCheck = true;
  nativeCheckInputs = [ protobuf ];

  meta = {
    description = "Maps google protobuf compiler to Ocaml types.";
    homepage = "https://github.com/issuu/ocaml-protoc-plugin";
    license = lib.licenses.asl20;
    longDescription = ''
      The goal of Ocaml protoc plugin is to create an
      up to date plugin for the google protobuf compiler
      (protoc) to generate Ocaml types and serialization
      and de-serialization function from a .proto file.
    '';
    maintainers = [ lib.maintainers.GirardR1006 ];
  };
}
