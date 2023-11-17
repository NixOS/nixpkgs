{ lib, stdenv
, fetchFromGitHub
, aws-c-common
, cmake
, nix
}:

stdenv.mkDerivation rec {
  pname = "aws-c-sdkutils";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-c-sdkutils";
    rev = "v${version}";
    sha256 = "sha256-4YuOC90FBcuNYGBsqw3wKYNGkg3MssezvR8bu6BNGeM=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    aws-c-common
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  doCheck = true;

  passthru.tests = {
    inherit nix;
  };

  meta = with lib; {
    description = "AWS SDK utility library";
    homepage = "https://github.com/awslabs/aws-c-sdkutils";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ r-burns ];
  };
}
