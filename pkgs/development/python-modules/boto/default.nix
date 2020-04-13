{ pkgs
, buildPythonPackage
, fetchPypi
, isPy38
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

  checkPhase = ''
    ${python.interpreter} tests/test.py default
  '';

  doCheck = (!isPy38); # hmac functionality has changed
  checkInputs = [ nose mock ];
  propagatedBuildInputs = [ requests httpretty ];

  meta = with pkgs.lib; {
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
