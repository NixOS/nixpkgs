{ stdenv
, buildPythonPackage
, fetchPypi
, dateutil
, sigtools
, six
, attrs
, od
, docutils
, repeated_test
, unittest2
, pygments
}:

buildPythonPackage rec {
  pname = "clize";
  version = "4.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dbcfba5571dc30aaf90dc98fc279e2aab69d0f8f3665fc0394fbc10a87a2be60";
  };

  checkInputs = [ 
    dateutil
    pygments
    repeated_test
    unittest2
  ];
  
  propagatedBuildInputs = [ 
    attrs
    docutils
    od
    sigtools
    six
  ];

  meta = with stdenv.lib; {
    description = "Command-line argument parsing for Python";
    homepage = "https://github.com/epsy/clize";
    license = licenses.mit;
  };

}
