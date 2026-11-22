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
  version = "0.36.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-amrRccw7snY/sAbJxcHD34XZwdMLLKCQjOU55e5pRik=";
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
