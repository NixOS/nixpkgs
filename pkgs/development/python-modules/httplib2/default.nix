{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, mock
, pyparsing
, pytest-forked
, pytest-randomly
, pytest-timeout
, pytest-xdist
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "httplib2";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "04y2bc2yv3q84llxnafqrciqxjqpxbrd8glbnvvr16c20fwc3r4q";
  };

  postPatch = ''
    sed -i "/--cov/d" setup.cfg
  '';

  propagatedBuildInputs = [ pyparsing ];

  checkInputs = [
    mock
    pytest-forked
    pytest-randomly
    pytest-timeout
    pytest-xdist
    six
    pytestCheckHook
  ];

  # Don't run tests for Python 2.7 or Darwin
  # Nearly 50% of the test suite requires local network access
  # which isn't allowed on sandboxed Darwin builds
  doCheck = !(isPy27 || stdenv.isDarwin);
  pytestFlagsArray = [ "--ignore python2" ];
  pythonImportsCheck = [ "httplib2" ];

  meta = with lib; {
    description = "A comprehensive HTTP client library";
    homepage = "https://httplib2.readthedocs.io";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
