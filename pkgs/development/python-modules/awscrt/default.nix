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
<<<<<<< HEAD
  version = "0.30.0";
=======
  version = "0.29.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-4aEzQw5xEW6cDxAbDREif0e3xWGtUwP1rwD2wzoW84I=";
=======
    hash = "sha256-D6GHTFohd2G2IlQ5PTq3r2v+qUfLqH044XEdV2/WPTE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ cmake ] ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ perl ];

  hardeningDisable = [ "fortify" ]; # needed for jitterentropy

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [ "awscrt" ];

  # Unable to import test module
  # https://github.com/awslabs/aws-crt-python/issues/281
  doCheck = false;

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/awslabs/aws-crt-python";
    changelog = "https://github.com/awslabs/aws-crt-python/releases/tag/v${version}";
    description = "Python bindings for the AWS Common Runtime";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ davegallant ];
=======
  meta = with lib; {
    homepage = "https://github.com/awslabs/aws-crt-python";
    changelog = "https://github.com/awslabs/aws-crt-python/releases/tag/v${version}";
    description = "Python bindings for the AWS Common Runtime";
    license = licenses.asl20;
    maintainers = with maintainers; [ davegallant ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
