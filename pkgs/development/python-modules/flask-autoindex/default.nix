{ stdenv
, buildPythonPackage
, fetchPypi
, flask
, flask-silk
, future
}:

buildPythonPackage rec {
  pname = "Flask-AutoIndex";
  version = "0.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0v87sa073hmj64f47sazbiw08kyxsxay100bd5084jwq7c1y92d7";
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
