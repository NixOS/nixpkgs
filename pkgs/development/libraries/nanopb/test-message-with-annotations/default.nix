{ stdenv, protobuf, nanopb }:

stdenv.mkDerivation {
  name = "nanopb-test-message-with-annotations";
  meta.timeout = 60;
  src = ./.;

  # protoc requires any .proto file to be compiled to reside within it's
  # proto_path. By default the current directory is automatically added to the
  # proto_path. I tried using --proto_path ${./.} ${./simple.proto} and it did
  # not work because they end up in the store at different locations.
  dontInstall = true;
  buildPhase = ''
    mkdir $out

    ${protobuf}/bin/protoc --proto_path=. --proto_path=${nanopb}/share/nanopb/generator/proto --plugin=protoc-gen-nanopb=${nanopb}/bin/protoc-gen-nanopb --nanopb_out=$out withannotations.proto
  '';

  doCheck = true;
  checkPhase = ''
    grep -q WithAnnotations $out/withannotations.pb.c || (echo "error: WithAnnotations not found in $out/withannotations.pb.c"; exit 1)
    grep -q WithAnnotations $out/withannotations.pb.h || (echo "error: WithAnnotations not found in $out/withannotations.pb.h"; exit 1)
    grep -q "pb_byte_t uuid\[16\]" $out/withannotations.pb.h || (echo "error: uuid is not of type pb_byte_t and of size 16 in $out/withannotations.pb.h"; exit 1)
    grep -q "FIXED_LENGTH_BYTES, uuid" $out/withannotations.pb.h || (echo "error: uuid is not of fixed lenght bytes in $out/withannotations.pb.h"; exit 1)
    grep -q "#define WithAnnotations_size" $out/withannotations.pb.h || (echo "error: the size of WithAnnotations is not known in $out/withannotations.pb.h"; exit 1)
  '';
}
