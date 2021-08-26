{ lib, buildPythonPackage, fetchFromGitHub, isPy27, pytestCheckHook, autoconf
, automake, cmake, gcc, libtool, perl, simplejson }:

buildPythonPackage rec {
  pname = "awslambdaric";
  version = "1.2.2";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-lambda-python-runtime-interface-client";
    rev = version;
    sha256 = "1r4b4w5xhf6p4vs7yx89kighlqim9f96v2ryknmrnmblgr4kg0h1";
  };

  postPatch = ''
    substituteInPlace requirements/base.txt \
      --replace 'simplejson==3' 'simplejson~=3'
  '';

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
