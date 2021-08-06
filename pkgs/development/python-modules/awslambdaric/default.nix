{ lib, buildPythonPackage, fetchFromGitHub, isPy27, pytestCheckHook, autoconf
, automake, cmake, gcc, libtool, perl, simplejson }:

buildPythonPackage rec {
  pname = "awslambdaric";
  version = "1.2.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-lambda-python-runtime-interface-client";
    rev = version;
    sha256 = "120qar8iaxj6dmnhjw1c40n2w06f1nyxy57dwh06xdiany698fg4";
  };

  propagatedBuildInputs = [ simplejson ];

  nativeBuildInputs = [ autoconf automake cmake libtool perl ];

  buildInputs = [ gcc ];

  dontUseCmakeConfigure = true;

  preBuild = ''
    substituteInPlace requirements/base.txt --replace 'simplejson==3' 'simplejson~=3'
  '';

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
