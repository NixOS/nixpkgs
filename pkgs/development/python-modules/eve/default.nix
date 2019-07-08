{ stdenv, buildPythonPackage, fetchPypi, flask, events
, pymongo, simplejson, cerberus, werkzeug }:

buildPythonPackage rec {
  pname = "Eve";
  version = "0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18shfaxa1vqshnyiqx3jqsri2wxz9ibip3mdxaz8pljmk734r4b1";
  };

  propagatedBuildInputs = [
    cerberus
    events
    flask
    pymongo
    simplejson
    werkzeug
  ];

  # tests call a running mongodb instance
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://python-eve.org/";
    description = "Open source Python REST API framework designed for human beings";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}
