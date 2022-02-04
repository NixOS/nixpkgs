{ lib, buildPythonPackage, fetchPypi, cmake, perl, stdenv, gcc10, CoreFoundation, Security }:

buildPythonPackage rec {
  pname = "awscrt";
  version = "0.13.1";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreFoundation Security ];

  # Required to suppress -Werror
  # https://github.com/NixOS/nixpkgs/issues/39687
  hardeningDisable = lib.optional stdenv.cc.isClang "strictoverflow";

  nativeBuildInputs = [ cmake ] ++
    # gcc <10 is not supported, LLVM on darwin is just fine
    lib.optionals (!stdenv.isDarwin && stdenv.isAarch64) [ gcc10 perl ];

  dontUseCmakeConfigure = true;

  # Unable to import test module
  # https://github.com/awslabs/aws-crt-python/issues/281
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1Qx3fcZ0I9RONLpFPDyXHkUEAF09KBgXV64NvepmDm8=";
  };

  meta = with lib; {
    homepage = "https://github.com/awslabs/aws-crt-python";
    description = "Python bindings for the AWS Common Runtime";
    license = licenses.asl20;
    maintainers = with maintainers; [ davegallant ];
  };
}
