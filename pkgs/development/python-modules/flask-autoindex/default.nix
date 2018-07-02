{ stdenv
, buildPythonPackage
, fetchFromGitHub
, flask
, flask-silk
, future
}:

buildPythonPackage rec {
  pname = "Flask-AutoIndex";
  version = "2018-06-28";

  # master fixes various issues (binary generation, flask syntax) and has no
  # major changes
  # new release requested: https://github.com/sublee/flask-autoindex/issues/38
  src = fetchFromGitHub {
    owner = "sublee";
    repo = "flask-autoindex";
    rev = "e3d449a89d56bf4c171c7c8d90af028e579782cf";
    sha256 = "0bwq2nid4h8vrxspggk064vra4wd804cl2ryyx4j2d1dyywmgjgy";
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
