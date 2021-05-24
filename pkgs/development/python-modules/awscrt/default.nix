{ lib, buildPythonPackage, fetchPypi, cmake, perl, stdenv, gcc10, darwin }:

buildPythonPackage rec {
  pname = "awscrt";
  version = "0.11.13";

  buildInputs = lib.optionals stdenv.isDarwin
    (with darwin.apple_sdk.frameworks; [ CoreFoundation Security ]);

  # Required to suppress -Werror
  # https://github.com/NixOS/nixpkgs/issues/39687
  hardeningDisable = lib.optional stdenv.cc.isClang "strictoverflow";

  nativeBuildInputs = [ cmake ] ++ lib.optionals stdenv.isAarch64 ([ gcc10 perl ]);

  dontUseCmakeConfigure = true;

  # Unable to import test module
  # https://github.com/awslabs/aws-crt-python/issues/281
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-G/bf2AzWp8AHL4of0zfX3jIYyTtmTLBIC2ZKiMi19c0=";
  };

  meta = with lib; {
    homepage = "https://github.com/awslabs/aws-crt-python";
    description = "Python bindings for the AWS Common Runtime";
    license = licenses.asl20;
    maintainers = with maintainers; [ davegallant ];
  };
}
