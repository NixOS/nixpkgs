{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  autoconf,
  automake,
  cmake,
  gcc,
  libtool,
  parameterized,
  perl,
  setuptools,
  simplejson,
  snapshot-restore-py,
}:
buildPythonPackage rec {
  pname = "awslambdaric";
  version = "4.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-lambda-python-runtime-interface-client";
    tag = version;
    hash = "sha256-Ft+95JMqm9yPQp4NDX8tC9PXSHMWlH1Qk9J+7T4V7fg=";
  };

  propagatedBuildInputs = [
    simplejson
    snapshot-restore-py
  ];

  nativeBuildInputs = [
    autoconf
    automake
    cmake
    libtool
    perl
    setuptools
  ];

  buildInputs = [ gcc ];

  dontUseCmakeConfigure = true;

  nativeCheckInputs = [
    parameterized
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "awslambdaric"
    "runtime_client"
  ];

  meta = {
    description = "AWS Lambda Runtime Interface Client for Python";
    homepage = "https://github.com/aws/aws-lambda-python-runtime-interface-client";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ austinbutler ];
    platforms = lib.platforms.linux;
  };
}
