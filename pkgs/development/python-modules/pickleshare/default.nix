{ stdenv
, buildPythonPackage
, fetchPypi
, pathpy
, pathlib2
, pythonOlder
}:

buildPythonPackage rec {
  version = "0.7.4";
  pname = "pickleshare";

  src = fetchPypi {
    inherit pname version;
    sha256 = "84a9257227dfdd6fe1b4be1319096c20eb85ff1e82c7932f36efccfe1b09737b";
  };

  propagatedBuildInputs = [ pathpy ]
    ++ stdenv.lib.optional (pythonOlder "3.4") pathlib2;

  # No proper test suite
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Tiny 'shelve'-like database with concurrency support";
    homepage = https://github.com/vivainio/pickleshare;
    license = licenses.mit;
  };

}
