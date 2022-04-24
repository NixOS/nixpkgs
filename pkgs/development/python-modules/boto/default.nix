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
  disabled = pythonAtLeast "3.10"; # cannot import name 'Mapping' from 'collections'

  src = fetchPypi {
    inherit pname version;
    sha256 = "ea0d3b40a2d852767be77ca343b58a9e3a4b00d9db440efb8da74b4e58025e5a";
  };

  patches = [
    # fixes hmac tests
    # https://sources.debian.org/src/python-boto/2.49.0-4/debian/patches/bug-953970_python3.8-compat.patch/
    ./bug-953970_python3.8-compat.patch
  ];

  checkPhase = ''
    ${python.interpreter} tests/test.py default
  '';

  checkInputs = [ nose mock ];
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
