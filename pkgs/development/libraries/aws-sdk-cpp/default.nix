{ lib, stdenv, fetchFromGitHub, cmake, curl
, # Allow building a limited set of APIs, e.g. ["s3" "ec2"].
  apis ? ["*"]
, # Whether to enable AWS' custom memory management.
  customMemoryManagement ? true
}:

stdenv.mkDerivation rec {
  name = "aws-sdk-cpp-${version}";
  version = "0.10.6";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-sdk-cpp";
    rev = version;
    sha256 = "1x3xam7vprlld6iqhqgdhgmqyclfy8dvzgy3375cijy9akhvv67i";
  };

  buildInputs = [ cmake curl ];

  cmakeFlags =
    lib.optional (!customMemoryManagement) "-DCUSTOM_MEMORY_MANAGEMENT=0"
    ++ lib.optional (apis != ["*"])
      "-DBUILD_ONLY=${lib.concatMapStringsSep ";" (api: "aws-cpp-sdk-" + api) apis}";

  enableParallelBuilding = true;

  preBuild =
    ''
      # Ensure that the unit tests can find the *.so files.
      for i in testing-resources aws-cpp-sdk-*; do
        export LD_LIBRARY_PATH=$(pwd)/$i:$LD_LIBRARY_PATH
      done
    '';

  postInstall =
    ''
      # Move the .so files to a more reasonable location.
      mv $out/lib/linux/*/Release/*.so $out/lib
      rm -rf $out/lib/linux
    '';

  meta = {
    description = "A C++ interface for Amazon Web Services";
    homepage = https://github.com/awslabs/aws-sdk-cpp;
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.eelco ];
  };
}
