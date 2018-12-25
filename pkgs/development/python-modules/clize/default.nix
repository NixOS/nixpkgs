{ stdenv
, buildPythonPackage
, fetchPypi
, dateutil
, sigtools
}:

buildPythonPackage rec {
  pname = "clize";
  version = "4.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dbcfba5571dc30aaf90dc98fc279e2aab69d0f8f3665fc0394fbc10a87a2be60";
  };

  buildInputs = [ dateutil ];
  propagatedBuildInputs = [ sigtools ];

  meta = with stdenv.lib; {
    description = "Command-line argument parsing for Python";
    homepage = "https://github.com/epsy/clize";
    license = licenses.mit;
  };

}
