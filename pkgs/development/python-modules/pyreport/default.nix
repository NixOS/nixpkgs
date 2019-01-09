{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "pyreport";
  version = "0.3.4c";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1584607596b7b310bf0b6ce79f424bd44238a017fd870aede11cd6732dbe0d4d";
  };

  # error: invalid command 'test'
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://pypi.python.org/pypi/pyreport;
    license = licenses.bsd0;
    description = "Pyreport makes notes out of a python script";
  };

}
