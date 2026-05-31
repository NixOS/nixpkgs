{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPy27,
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
  version = "3.1.1";
  pyproject = true;

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-lambda-python-runtime-interface-client";
    tag = version;
    sha256 = "sha256-gwbEDo/LewCb0wTtkw/bF3XSAiSu1ITYHAnuvpNsfs0=";
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
