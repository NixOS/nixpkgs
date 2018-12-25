{ stdenv
, buildPythonPackage
, fetchPypi
, flask
, flask-silk
, future
}:

buildPythonPackage rec {
  pname = "Flask-AutoIndex";
  version = "0.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "af2cdb34eefe6edbf43ce19200880829e8c2df3598000e75dc63c9b7e3478706";
  };

  propagatedBuildInputs = [
    flask
    flask-silk
    future
  ];

  meta = with stdenv.lib; {
    description = "The mod_autoindex for Flask";
    longDescription = ''
      Flask-AutoIndex generates an index page for your Flask application automatically.
      The result is just like mod_autoindex, but the look is more awesome!
    '';
    license = licenses.bsd2;
    maintainers = with maintainers; [ timokau ];
    homepage = https://pythonhosted.org/Flask-AutoIndex/;
  };
}
