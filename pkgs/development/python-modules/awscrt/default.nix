{ lib
, buildPythonPackage
, fetchPypi
, cmake
, perl
, stdenv
, gcc10
, CoreFoundation
, Security
, pythonOlder
}:

buildPythonPackage rec {
  pname = "awscrt";
  version = "0.13.7";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FCmdYuXh8+nWfeGbJ9IhfwASFsZoxOp7jL+5/TrtG5Q=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreFoundation
    Security
  ];

  # Required to suppress -Werror
  # https://github.com/NixOS/nixpkgs/issues/39687
  hardeningDisable = lib.optionals stdenv.cc.isClang [
    "strictoverflow"
  ];

  # gcc <10 is not supported, LLVM on darwin is just fine
  nativeBuildInputs = [
    cmake
  ] ++ lib.optionals (!stdenv.isDarwin && stdenv.isAarch64) [
    gcc10
    perl
  ];

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [
    "awscrt"
  ];

  # Unable to import test module
  # https://github.com/awslabs/aws-crt-python/issues/281
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/awslabs/aws-crt-python";
    description = "Python bindings for the AWS Common Runtime";
    license = licenses.asl20;
    maintainers = with maintainers; [ davegallant ];
  };
}
