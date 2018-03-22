{ stdenv, buildPythonPackage, fetchPypi, six }:
buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "python-dateutil";
  version = "2.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jkahssf0ir5ssxc3ydbp8cpv77limn8d4s77szb2nrgl2r3h749";
  };

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    description = "Powerful extensions to the standard datetime module";
    homepage = https://pypi.python.org/pypi/python-dateutil;
    license = "BSD-style";
  };
}
