{ stdenv
, buildPythonPackage
, fetchpatch
, fetchPypi
, flask
, flask-silk
, future
}:

buildPythonPackage rec {
  pname = "Flask-AutoIndex";
  version = "0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19b10mb1nrqfjyafki6wnrbn8mqi30bbyyiyvp5xssc74pciyfqs";
  };

  propagatedBuildInputs = [
    flask
    flask-silk
    future
  ];

  patches = [
    # fix generated binary, see https://github.com/sublee/flask-autoindex/pull/32
    (fetchpatch {
      name = "fix_binary.patch";
      url = "https://github.com/sublee/flask-autoindex/pull/32.patch";
      sha256 = "1v2r0wvi7prhipjq89774svv6aqj0a13mdfj07pdlkpzfbf029dn";
    })
  ];

  meta = with stdenv.lib; {
    description = "The mod_autoindex for Flask";
    longDescription = ''
      Flask-AutoIndex generates an index page for your Flask application automatically.
      The result is just like mod_autoindex, but the look is more awesome!
    '';
    license = licenses.bsd2;
    maintainers = with maintainers; [ timokau ];
    homepage = http://pythonhosted.org/Flask-AutoIndex/;
  };
}
