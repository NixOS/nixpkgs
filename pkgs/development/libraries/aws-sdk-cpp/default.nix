{ lib, stdenv, fetchFromGitHub, cmake, curl, openssl, zlib
, # Allow building a limited set of APIs, e.g. ["s3" "ec2"].
  apis ? ["*"]
, # Whether to enable AWS' custom memory management.
  customMemoryManagement ? true
}:

let
  loaderVar =
    if stdenv.isLinux
      then "LD_LIBRARY_PATH"
      else if stdenv.isDarwin
        then "DYLD_LIBRARY_PATH"
        else throw "Unsupported system!";
in stdenv.mkDerivation rec {
  name = "aws-sdk-cpp-${version}";
  version = "1.3.22";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-sdk-cpp";
    rev = version;
    sha256 = "0sdgy8kqhxnw7n0sw4m3p3ay7yic3rhad5ab8m5lbx61ad9bq3c2";
  };

  # FIXME: might be nice to put different APIs in different outputs
  # (e.g. libaws-cpp-sdk-s3.so in output "s3").
  outputs = [ "out" "dev" ];
  separateDebugInfo = stdenv.isLinux;

  nativeBuildInputs = [ cmake curl ];
  buildInputs = [ zlib curl openssl ];

  cmakeFlags =
    lib.optional (!customMemoryManagement) "-DCUSTOM_MEMORY_MANAGEMENT=0"
    ++ lib.optional (stdenv.buildPlatform != stdenv.hostPlatform) "-DENABLE_TESTING=OFF"
    ++ lib.optional (apis != ["*"])
      "-DBUILD_ONLY=${lib.concatStringsSep ";" apis}";

  enableParallelBuilding = true;

  # Behold the escaping nightmare below on loaderVar o.O
  preBuild =
    ''
      # Ensure that the unit tests can find the *.so files.
      for i in testing-resources aws-cpp-sdk-*; do
        export ${loaderVar}=$(pwd)/$i:''${${loaderVar}}
      done
    '';

  preConfigure =
    ''
      rm aws-cpp-sdk-core-tests/aws/auth/AWSCredentialsProviderTest.cpp
    '';

  meta = {
    description = "A C++ interface for Amazon Web Services";
    homepage = https://github.com/awslabs/aws-sdk-cpp;
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = [ lib.maintainers.eelco ];
  };
}
