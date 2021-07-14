{ lib, buildPythonPackage, fetchFromGitHub, isPy27, pytestCheckHook, autoconf
, automake, cmake, gcc, libtool, perl, simplejson }:

buildPythonPackage rec {
  pname = "awslambdaric";
  version = "1.1.1";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-lambda-python-runtime-interface-client";
    rev = version;
    sha256 = "1f8828y32yrf87bc933jhmjrvj746baibvpn0w21x3ji81vf6mri";
  };

  propagatedBuildInputs = [ simplejson ];

  nativeBuildInputs = [ autoconf automake cmake libtool perl ];

  buildInputs = [ gcc ];

  dontUseCmakeConfigure = true;

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "awslambdaric" "runtime_client" ];

  meta = with lib; {
    description = "AWS Lambda Runtime Interface Client for Python";
    homepage = "https://github.com/aws/aws-lambda-python-runtime-interface-client";
    license = licenses.asl20;
    maintainers = with maintainers; [ austinbutler ];
    platforms = platforms.linux;
  };
}
