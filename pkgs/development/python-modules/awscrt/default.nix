{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  cmake,
  perl,
  stdenv,
}:

buildPythonPackage rec {
  pname = "awscrt";
  version = "0.29.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-x42BsTCNQv2h6yHSf88mV5E3uCEEPlKFUPLPxsCauf8=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ cmake ] ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ perl ];

  hardeningDisable = [ "fortify" ]; # needed for jitterentropy

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [ "awscrt" ];

  # Unable to import test module
  # https://github.com/awslabs/aws-crt-python/issues/281
  doCheck = false;

  meta = {
    homepage = "https://github.com/awslabs/aws-crt-python";
    changelog = "https://github.com/awslabs/aws-crt-python/releases/tag/v${version}";
    description = "Python bindings for the AWS Common Runtime";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ davegallant ];
  };
}
