{
  lib,
  buildPythonPackage,
  fetchPypi,
  cmake,
  perl,
  stdenv,
  CoreFoundation,
  Security,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "awscrt";
  version = "0.24.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sqa/+5nFbDYmjRNZrYM8F58xrnlsz77Zv1XDSEbhMdA=";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    CoreFoundation
    Security
  ];

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
