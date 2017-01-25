{ lib, stdenv, fetchFromGitHub, cmake, curl, openssl, zlib
, # Allow building a limited set of APIs, e.g. ["s3" "ec2"].
  apis ? ["*"]
, # Whether to enable AWS' custom memory management.
  customMemoryManagement ? true
}:

stdenv.mkDerivation rec {
  name = "aws-sdk-cpp-${version}";
  version = "1.0.48";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-sdk-cpp";
    rev = version;
    sha256 = "1k73ir1w6457y9mdv2xnk8cr1y1xxhzzd4095rzvn2y7fr3zgz01";
  };

  # FIXME: might be nice to put different APIs in different outputs
  # (e.g. libaws-cpp-sdk-s3.so in output "s3").
  outputs = [ "out" "dev" ];

  buildInputs = [ cmake curl ];

  cmakeFlags =
    lib.optional (!customMemoryManagement) "-DCUSTOM_MEMORY_MANAGEMENT=0"
    ++ lib.optional (apis != ["*"])
      "-DBUILD_ONLY=${lib.concatStringsSep ";" apis}";

  enableParallelBuilding = true;

  preBuild =
    ''
      # Ensure that the unit tests can find the *.so files.
      for i in testing-resources aws-cpp-sdk-*; do
        export LD_LIBRARY_PATH=$(pwd)/$i:$LD_LIBRARY_PATH
      done
    '';

  NIX_LDFLAGS = lib.concatStringsSep " " (
    (map (pkg: "-rpath ${lib.getOutput "lib" pkg}/lib"))
      [ curl openssl zlib stdenv.cc.cc ]);

  meta = {
    description = "A C++ interface for Amazon Web Services";
    homepage = https://github.com/awslabs/aws-sdk-cpp;
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = [ lib.maintainers.eelco ];
  };
}
