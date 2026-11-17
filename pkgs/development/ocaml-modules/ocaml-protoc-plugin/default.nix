{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  pkg-config,
  protobuf,
  zarith,
  ppx_deriving,
  ppx_deriving_yojson,
  re,
  dune-site,
  ppx_expect,
  ptime,
  base64,
  omd,
}:

buildDunePackage (finalAttrs: {
  pname = "ocaml-protoc-plugin";
  version = "6.3.0";

  src = fetchFromGitHub {
    owner = "andersfugmann";
    repo = "ocaml-protoc-plugin";
    rev = finalAttrs.version;
    hash = "sha256-FGECg2RUejTmJNi2BSZnuP78ctDEWOiVwCAcazhnoOw=";
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
    ptime
    base64
    omd
  ];
  doCheck = true;
  nativeCheckInputs = [ protobuf ];

  meta = {
    description = "Maps google protobuf compiler to Ocaml types";
    homepage = "https://github.com/andersfugmann/ocaml-protoc-plugin";
    license = lib.licenses.asl20;
    longDescription = ''
      The goal of Ocaml protoc plugin is to create an
      up to date plugin for the google protobuf compiler
      (protoc) to generate Ocaml types and serialization
      and de-serialization function from a .proto file.
    '';
    maintainers = [ lib.maintainers.GirardR1006 ];
  };
})
