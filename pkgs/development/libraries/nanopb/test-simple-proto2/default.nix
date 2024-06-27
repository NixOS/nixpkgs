{ lib, stdenv, protobuf, nanopb }:

stdenv.mkDerivation {
  name = "nanopb-test-simple-proto2";
  meta.timeout = 60;
  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [ ./simple.proto ];
  };

  # protoc requires any .proto file to be compiled to reside within it's
  # proto_path. By default the current directory is automatically added to the
  # proto_path. I tried using --proto_path ${./.} ${./simple.proto} and it did
  # not work because they end up in the store at different locations.
  dontInstall = true;
  buildPhase = ''
    mkdir $out

    ${protobuf}/bin/protoc --plugin=protoc-gen-nanopb=${nanopb}/bin/protoc-gen-nanopb --nanopb_out=$out simple.proto
  '';

  doCheck = true;
  checkPhase = ''
    grep -q SimpleMessage $out/simple.pb.c || (echo "ERROR: SimpleMessage not found in $out/simple.pb.c"; exit 1)
    grep -q SimpleMessage $out/simple.pb.h || (echo "ERROR: SimpleMessage not found in $out/simple.pb.h"; exit 1)
  '';
}
