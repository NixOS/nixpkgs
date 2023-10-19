{ lib
, stdenv
, fetchFromGitHub
, cmake
, aws-c-cal
, aws-c-common
, nix
, s2n-tls
, Security
}:

stdenv.mkDerivation rec {
  pname = "aws-c-io";
  version = "0.13.35";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-o6ZUfKBKZZczZFCiDpZVcC58DWDbRpaO2bBfptFlxiY=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    aws-c-cal
    aws-c-common
    s2n-tls
  ];

  propagatedBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    Security
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  passthru.tests = {
    inherit nix;
  };

  meta = with lib; {
    description = "AWS SDK for C module for IO and TLS";
    homepage = "https://github.com/awslabs/aws-c-io";
    changelog = "https://github.com/awslabs/aws-c-io/releases/tag/v${version}";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej ];
  };
}
