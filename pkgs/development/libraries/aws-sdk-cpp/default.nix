{ lib, stdenv, fetchFromGitHub, cmake, curl }:

stdenv.mkDerivation rec {
  name = "aws-sdk-cpp-${version}";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-sdk-cpp";
    rev = version;
    sha256 = "022v7naa5vjvq3wfn4mcp99li61ffsk2fnc8qqi52cb1pyxz9sk1";
  };

  buildInputs = [ cmake curl ];

  # FIXME: provide flags to build only part of the SDK, or put them in
  # different outputs.
  # cmakeFlags = "-DBUILD_ONLY=aws-cpp-sdk-s3";

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
