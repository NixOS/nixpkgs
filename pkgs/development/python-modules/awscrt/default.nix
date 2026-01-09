{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  cmake,
  perl,
  stdenv,
}:

buildPythonPackage (finalAttrs: {
  pname = "awscrt";
  version = "0.31.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-3sYhdPC5viwybu2gYudE67+qi27HKH9SaHt61DARW78=";
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
    changelog = "https://github.com/awslabs/aws-crt-python/releases/tag/v${finalAttrs.version}";
    description = "Python bindings for the AWS Common Runtime";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ davegallant ];
  };
})
