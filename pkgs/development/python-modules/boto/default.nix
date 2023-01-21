{ lib
, buildPythonPackage
, fetchPypi
, pythonAtLeast
, python
, nose
, mock
, requests
, httpretty
}:

buildPythonPackage rec {
  pname = "boto";
  version = "2.49.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ea0d3b40a2d852767be77ca343b58a9e3a4b00d9db440efb8da74b4e58025e5a";
  };

  patches = [
    # fixes hmac tests
    # https://sources.debian.org/src/python-boto/2.49.0-4/debian/patches/bug-953970_python3.8-compat.patch/
    ./bug-953970_python3.8-compat.patch
  ];

  # boto is deprecated by upstream as of 2021-05-27 (https://github.com/boto/boto/commit/4980ac58764c3d401cb0b9552101f9c61c18f445)
  # this patch is a bit simpler than https://github.com/boto/boto/pull/3898
  # as we don't have to take care of pythonOlder "3.3".
  postPatch = ''
    substituteInPlace boto/dynamodb/types.py --replace 'from collections import Mapping' 'from collections.abc import Mapping'
    substituteInPlace boto/mws/connection.py --replace 'import collections' 'import collections.abc as collections'
  '';

  checkPhase = ''
    ${python.interpreter} tests/test.py default
  '';

  nativeCheckInputs = [ nose mock ];
  propagatedBuildInputs = [ requests httpretty ];

  meta = with lib; {
    homepage = "https://github.com/boto/boto";
    license = licenses.mit;
    description = "Python interface to Amazon Web Services";
    longDescription = ''
      The boto module is an integrated interface to current and
      future infrastructural services offered by Amazon Web
      Services.  This includes S3, SQS, EC2, among others.
    '';
    maintainers = [ maintainers.costrouc ];
  };
}
