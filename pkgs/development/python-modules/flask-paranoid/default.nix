{ stdenv
, buildPythonPackage
, python
, fetchPypi
, flask
}:

buildPythonPackage rec {
  pname = "Flask-Paranoid";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0jf7f31pwiqd6dwhiyhwcix1c9d7l5aam93q2pqm80ifcibr5vm2";
  };

  propagatedBuildInputs = [
    flask
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Simple user session protection";
    longDescription = ''
      When a client connects to an application, a "paranoid" token will be
      generated according to the IP address and user agent. In all subsequent
      requests, the token will be recalculated and checked against the one
      computed for the first request. If the session cookie is stolen and the
      attacker tries to use it from another location, the generated token will
      be different, and in that case the extension will clear the session and
      block the request.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ kuznero ];
    homepage = https://github.com/miguelgrinberg/flask-paranoid;
  };
}
