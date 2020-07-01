{ stdenv
, buildPythonPackage
, fetchPypi
, fetchpatch
, flask
, flask-common
, flask-limiter
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

  src = fetchPypi {
    inherit pname version;
    sha256 = "0afa0486a76305cac441b5cc80d5d4ccd82b20875da7c5119ecfe616cefef45f";
  };

  patches = [
    # https://github.com/kennethreitz/httpbin/issues/403
    # https://github.com/kennethreitz/flask-common/issues/7
    # https://github.com/evansd/whitenoise/issues/166
    (fetchpatch {
      url = "https://github.com/javabrett/httpbin/commit/5735c888e1e51b369fcec41b91670a90535e661e.patch";
      sha256 = "167h8mscdjagml33dyqk8nziiz3dqbggnkl6agsirk5270nl5f7q";
    })
  ];

  propagatedBuildInputs = [ brotlipy flask flask-common flask-limiter markupsafe decorator itsdangerous raven six ];

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/kennethreitz/httpbin";
    description = "HTTP Request & Response Service";
    license = licenses.mit;
  };
}
