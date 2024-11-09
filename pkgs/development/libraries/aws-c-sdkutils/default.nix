{ lib, stdenv
, fetchFromGitHub
, aws-c-common
, cmake
, nix
}:

stdenv.mkDerivation rec {
  pname = "aws-c-sdkutils";
  version = "0.1.16";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-c-sdkutils";
    rev = "v${version}";
    hash = "sha256-ih7U2uP5FrBx6or1Rp/k+HWDE6evEZyNM//wsPxH9Qo=";
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
