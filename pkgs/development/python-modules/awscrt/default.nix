{
  lib,
  buildPythonPackage,
  fetchPypi,
  cmake,
  perl,
  stdenv,
  gcc10,
  CoreFoundation,
  Security,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "awscrt";
  version = "0.20.10";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vGmN6MU61KLqsWRrkhlqWE6tFwplxltZyIOFWt6lly8=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreFoundation
    Security
  ];

  # gcc <10 is not supported, LLVM on darwin is just fine
  nativeBuildInputs =
    [ cmake ]
    ++ lib.optionals (!stdenv.isDarwin && stdenv.isAarch64) [
      gcc10
      perl
    ];

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [ "awscrt" ];

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
