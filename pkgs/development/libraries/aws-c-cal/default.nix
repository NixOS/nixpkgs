{ lib, stdenv, fetchFromGitHub, cmake, aws-c-common, nix, openssl, Security }:

stdenv.mkDerivation rec {
  pname = "aws-c-cal";
  version = "0.5.26";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-X325dMH3mZBvRqZ540ZsmcJ/N5PbDxzGDf5Gi+XXP0c=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ aws-c-common openssl ];

  propagatedBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ Security ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  passthru.tests = {
    inherit nix;
  };

  meta = with lib; {
    description = "AWS Crypto Abstraction Layer ";
    homepage = "https://github.com/awslabs/aws-c-cal";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej ];
  };
}
