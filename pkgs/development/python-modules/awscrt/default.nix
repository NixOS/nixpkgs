{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  cmake,
  perl,
  stdenv,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "awscrt";
  version = "0.26.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qNY6fcxkhMXBZ1sxqNG2cmw9yFsTeW+xQ9+wByJgk14=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ cmake ] ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ perl ];

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
