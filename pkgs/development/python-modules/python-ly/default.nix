{ buildPythonPackage, fetchPypi, stdenv }:

buildPythonPackage rec {
  pname = "python-ly";
  version = "0.9.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0s5hvsf17f4w1xszrf4pg29wfv9znkj195klq1v2qhlpxfp6772d";
  };

  # tests not shipped on `pypi` and
  # seem to be broken ATM: https://github.com/wbsoft/python-ly/issues/70
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Tool and library for manipulating LilyPond files";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ];
  };
}
