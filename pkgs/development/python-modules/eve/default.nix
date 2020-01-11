{ stdenv, buildPythonPackage, fetchPypi, flask, events
, pymongo, simplejson, cerberus, werkzeug }:

buildPythonPackage rec {
  pname = "Eve";
  version = "1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ebde455e631b8eb9d38783eedfbd7e416b4477cce3d9988880eb3e477256a11e";
  };

  propagatedBuildInputs = [
    cerberus
    events
    flask
    pymongo
    simplejson
    werkzeug
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "werkzeug==0.15.4" "werkzeug"
  '';

  # tests call a running mongodb instance
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://python-eve.org/";
    description = "Open source Python REST API framework designed for human beings";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}
