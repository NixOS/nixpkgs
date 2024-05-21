{ lib, stdenv, fetchFromGitHub, cmake, aws-c-common, nix, openssl, Security }:

stdenv.mkDerivation (finalAttrs: {
  pname = "aws-c-cal";
  version = "0.6.12";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-aegK01wYdOc6RGNVf/dZKn1HkqQr+yEblcu6hnlMZE4=";
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
    description = "AWS Crypto Abstraction Layer ";
    homepage = "https://github.com/awslabs/aws-c-cal";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej ];
  };
})
