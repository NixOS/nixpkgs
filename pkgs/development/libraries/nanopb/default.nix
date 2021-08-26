{ callPackage
, cmake
, fetchFromGitHub
, lib
, protobuf
, python3
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "nanopb";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "0cjfkwwzi018kc0b7lia7z2jdfgibqc99mf8rvj2xq2pfapp9kf1";
  };

  nativeBuildInputs = [ cmake python3 python3.pkgs.wrapPython ];

  pythonPath = with python3.pkgs; [ python3.pkgs.protobuf six ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON" # generate $out/lib/libprotobuf-nanopb.so{.0,}
    "-DBUILD_STATIC_LIBS=ON" # generate $out/lib/libprotobuf-nanopb.a
    "-Dnanopb_PROTOC_PATH=${protobuf}/bin/protoc"
  ];

  postInstall = ''
    mkdir -p $out/share/nanopb/generator/proto
    cp ../generator/proto/nanopb.proto $out/share/nanopb/generator/proto/nanopb.proto
    cp ../pb_common.c ../pb_decode.c ../pb_encode.c $out/include/
  '';

  postFixup = ''
    wrapPythonPrograms
  '';

  passthru.tests = {
    simple-proto2 = callPackage ./test-simple-proto2 {};
    simple-proto3 = callPackage ./test-simple-proto3 {};
    message-with-annotations = callPackage ./test-message-with-annotations {};
    message-with-options = callPackage ./test-message-with-options {};
  };

  meta = with lib; {
    inherit (protobuf.meta) platforms;

    description = "Protocol Buffers with small code size";
    homepage = "https://jpa.kapsi.fi/nanopb/";
    license = licenses.zlib;
    maintainers = with maintainers; [ kalbasit ];

    longDescription = ''
      Nanopb is a small code-size Protocol Buffers implementation in ansi C. It
      is especially suitable for use in microcontrollers, but fits any memory
      restricted system.

      - Homepage: jpa.kapsi.fi/nanopb
      - Documentation: jpa.kapsi.fi/nanopb/docs
      - Downloads: jpa.kapsi.fi/nanopb/download
      - Forum: groups.google.com/forum/#!forum/nanopb

      In order to use the nanopb options in your proto files, you'll need to
      tell protoc where to find the nanopb.proto file.
      You can do so with the --proto_path (-I) option to add the directory
      ''${nanopb}/share/nanopb/generator/proto like so:

      protoc --proto_path=. --proto_path=''${nanopb}/share/nanopb/generator/proto --plugin=protoc-gen-nanopb=''${nanopb}/bin/protoc-gen-nanopb --nanopb_out=out file.proto
    '';
  };
}
