{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "process-tests";
  version = "2.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7ae24a680cc7c44e7687e3723e6e64597a28223ad664989999efe10dd38c2431";
  };

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Tools for testing processes";
    license = licenses.bsd2;
    homepage = https://github.com/ionelmc/python-process-tests;
  };

}
