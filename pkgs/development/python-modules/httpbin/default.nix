{ stdenv
, buildPythonPackage
, fetchPypi
, flask
, flask_common
, flask_limiter
, markupsafe
, decorator
, itsdangerous
, raven
, six
, brotlipy
}:

buildPythonPackage rec {
  pname = "httpbin";
  version = "0.6.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0afa0486a76305cac441b5cc80d5d4ccd82b20875da7c5119ecfe616cefef45f";
  };

  propagatedBuildInputs = [ brotlipy flask flask_common flask_limiter markupsafe decorator itsdangerous raven six ];

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/kennethreitz/httpbin;
    description = "HTTP Request & Response Service";
    license = licenses.mit;
  };
}
