{
  lib,
  buildPythonPackage,
  fetchPypi,
  httpretty,
  mock,
  nose,
  python,
  pythonAtLeast,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "boto";
  version = "2.49.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6g07QKLYUnZ753yjQ7WKnjpLANnbRA77jadLTlgCXlo=";
  };

  patches = [
    # fixes hmac tests
    # https://sources.debian.org/src/python-boto/2.49.0-4/debian/patches/bug-953970_python3.8-compat.patch/
    ./bug-953970_python3.8-compat.patch
    # fixes test_startElement_with_name_tagSet_calls_ResultSet
    # https://sources.debian.org/src/python-boto/2.49.0-4.1/debian/patches/0005-Don-t-mock-list-subclass.patch/
    ./0005-Don-t-mock-list-subclass.patch
  ];

  # boto is deprecated by upstream as of 2021-05-27 (https://github.com/boto/boto/commit/4980ac58764c3d401cb0b9552101f9c61c18f445)
  # this patch is a bit simpler than https://github.com/boto/boto/pull/3898
  # as we don't have to take care of pythonOlder "3.3".
  postPatch = ''
    substituteInPlace boto/dynamodb/types.py \
      --replace-fail 'from collections import Mapping' 'from collections.abc import Mapping'
    substituteInPlace boto/mws/connection.py \
      --replace-fail 'import collections' 'import collections.abc as collections'
  '';

  build-system = [ setuptools ];

  dependencies = [
    requests
    httpretty
  ];

  nativeCheckInputs = [
    mock
    nose
  ];

  checkPhase = ''
    ${python.interpreter} tests/test.py default
  '';

  pythonImportsCheck = [ "boto" ];

  meta = with lib; {
    description = "Python interface to Amazon Web Services";
    longDescription = ''
      The boto module is an integrated interface to current and
      future infrastructural services offered by Amazon Web
      Services. This includes S3, SQS, EC2, among others.
    '';
    homepage = "https://github.com/boto/boto";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
