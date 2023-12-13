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
  version = "0.19.18";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NQtu/Y6+4ILqPz5SxZo8PsWUza8B24tIU9zrn+yQyJ0=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreFoundation
    Security
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
    changelog = "https://github.com/awslabs/aws-crt-python/releases/tag/v${version}";
    description = "Python bindings for the AWS Common Runtime";
    license = licenses.asl20;
    maintainers = with maintainers; [ davegallant ];
  };
}
