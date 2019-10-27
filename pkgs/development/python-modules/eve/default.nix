{ stdenv, buildPythonPackage, fetchPypi, flask, events
, pymongo, simplejson, cerberus, werkzeug }:

buildPythonPackage rec {
  pname = "Eve";
  version = "0.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0191ed42ef85d747758bba29df5ff1e296b8152fefddb2f75c3d778c2e6fb9d3";
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
