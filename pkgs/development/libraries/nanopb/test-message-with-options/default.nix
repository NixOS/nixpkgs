{ lib, stdenv, protobuf, nanopb }:

stdenv.mkDerivation {
  name = "nanopb-test-message-with-options";
  meta.timeout = 60;
  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./withoptions.proto
      ./withoptions.options
    ];
  };

  # protoc requires any .proto file to be compiled to reside within it's
  # proto_path. By default the current directory is automatically added to the
  # proto_path. I tried using --proto_path ${./.} ${./simple.proto} and it did
  # not work because they end up in the store at different locations.
  dontInstall = true;
  buildPhase = ''
    mkdir $out

    ${protobuf}/bin/protoc --plugin=protoc-gen-nanopb=${nanopb}/bin/protoc-gen-nanopb --nanopb_out=$out withoptions.proto
  '';

  doCheck = true;
  checkPhase = ''
    grep -q WithOptions $out/withoptions.pb.c || (echo "error: WithOptions not found in $out/withoptions.pb.c"; exit 1)
    grep -q WithOptions $out/withoptions.pb.h || (echo "error: WithOptions not found in $out/withoptions.pb.h"; exit 1)
    grep -q "pb_byte_t uuid\[16\]" $out/withoptions.pb.h || (echo "error: uuid is not of type pb_byte_t and of size 16 in $out/withoptions.pb.h"; exit 1)
    grep -q "FIXED_LENGTH_BYTES, uuid" $out/withoptions.pb.h || (echo "error: uuid is not of fixed lenght bytes in $out/withoptions.pb.h"; exit 1)
    grep -q "#define WithOptions_size" $out/withoptions.pb.h || (echo "error: the size of WithOptions is not known in $out/withoptions.pb.h"; exit 1)
  '';
}
