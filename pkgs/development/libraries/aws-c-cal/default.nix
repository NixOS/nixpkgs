{ lib, stdenv, fetchFromGitHub, cmake, aws-c-common, nix, openssl, Security }:

stdenv.mkDerivation (finalAttrs: {
  pname = "aws-c-cal";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-c-cal";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0YNTfsOSZAjY4f3fwTBtZTjaa3ebi8iXF1Fv8XexHPE=";
  };

  patches = [
    # Fix openssl adaptor code for musl based static binaries.
    ./aws-c-cal-musl-compat.patch
  ];

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
    description = "AWS Crypto Abstraction Layer";
    homepage = "https://github.com/awslabs/aws-c-cal";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej ];
  };
})
