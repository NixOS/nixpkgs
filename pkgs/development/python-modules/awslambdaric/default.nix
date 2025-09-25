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
    sha256 = "sha256-pUVWd4zpmTygndPIy76uVk7+sLCmwQqulLaUI7B0fQc=";
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

  meta = with lib; {
    description = "AWS Lambda Runtime Interface Client for Python";
    homepage = "https://github.com/aws/aws-lambda-python-runtime-interface-client";
    license = licenses.asl20;
    maintainers = with maintainers; [ austinbutler ];
    platforms = platforms.linux;
  };
}
