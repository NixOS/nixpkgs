{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, isPy27
, pytestCheckHook
, autoconf
, automake
, cmake
, gcc
, libtool
, perl
, simplejson
}:

buildPythonPackage rec {
  pname = "awslambdaric";
  version = "2.0.7";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-lambda-python-runtime-interface-client";
    rev = "refs/tags/${version}";
    sha256 = "sha256-9PgdLzeSafglguXksMetzopbDlBWlGDSSXiZHfuWgE8=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/aws/aws-lambda-python-runtime-interface-client/pull/58
      url = "https://github.com/aws/aws-lambda-python-runtime-interface-client/commit/162c3c0051bb9daa92e4a2a4af7e90aea60ee405.patch";
      sha256 = "09qqq5x6npc9jw2qbhzifqn5sqiby4smiin1aw30psmlp21fv7j8";
    })
  ];

  postPatch = ''
    substituteInPlace requirements/base.txt \
      --replace 'simplejson==3' 'simplejson~=3'
  '';

  propagatedBuildInputs = [ simplejson ];

  nativeBuildInputs = [ autoconf automake cmake libtool perl ];

  buildInputs = [ gcc ];

  dontUseCmakeConfigure = true;

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Test fails with: Assertion error
    "test_handle_event_request_fault_exception_logging_syntax_error"
  ];

  pythonImportsCheck = [ "awslambdaric" "runtime_client" ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "AWS Lambda Runtime Interface Client for Python";
    homepage = "https://github.com/aws/aws-lambda-python-runtime-interface-client";
    license = licenses.asl20;
    maintainers = with maintainers; [ austinbutler ];
    platforms = platforms.linux;
  };
}
