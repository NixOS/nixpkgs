{ buildPythonPackage
, aws-sdk-cpp
, cmake
, curl
, fetchFromGitHub
, lib
, pybind11
, pytorch
, zlib
}:

let
  aws-sdk-cpp-s3-transfer = (aws-sdk-cpp.override {
    apis = ["s3" "transfer"];
    customMemoryManagement = false;
  }).overrideAttrs (oldAttrs: {

    # Fixes downstream issue with dependent CMake configuration
    # See https://github.com/NixOS/nixpkgs/issues/70075#issuecomment-1019328864
    postPatch = oldAttrs.postPatch + ''
      substituteInPlace cmake/AWSSDKConfig.cmake \
        --replace "\''${AWSSDK_DEFAULT_ROOT_DIR}/\''${AWSSDK_INSTALL_INCLUDEDIR}" "\''${AWSSDK_INSTALL_INCLUDEDIR}"
    '';

});
in
buildPythonPackage rec {
  pname = "amazon-s3-plugin-for-pytorch";

  version = "0.0.1-38284c8"; # No official release published yet

  src = fetchFromGitHub {
    owner = "aws";
    repo = pname;
    rev = "38284c8a5e92be3bbf47b08e8c90d94be0cb79e7";
    sha256 = "0lww4y3mq854za95hi4y441as4r3h3q0nyrpgj4j6kjk58gijbx9";
  };

  dontUseCmakeConfigure = true; # Allow setup.py to take care of building _pywrap_s3_io via build_ext

  nativeBuildInputs = [
    cmake
    zlib
  ];

  buildInputs = [
    aws-sdk-cpp-s3-transfer
    pybind11
    curl
  ];

  propagatedBuildInputs = [
    pytorch
  ];

  pythonImportsCheck = [ "awsio.python.lib.io.s3.s3dataset" ];

  doCheck = false; # More or less every test requires a network connection

  meta = with lib; {
    description = "S3-plugin is a high performance PyTorch dataset library to efficiently access datasets stored in S3 buckets.";
    homepage = "https://github.com/aws/amazon-s3-plugin-for-pytorch";
    license = licenses.asl20;
    maintainers = with maintainers; [];
  };
}
