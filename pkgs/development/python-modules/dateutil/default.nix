{ stdenv, buildPythonPackage, fetchurl, six }:
buildPythonPackage rec {
  pname = "dateutil";
  name = "${pname}-${version}";
  version = "2.6.1";

  src = fetchurl {
    url = "mirror://pypi/p/python-dateutil/python-${name}.tar.gz";
    sha256 = "1jkahssf0ir5ssxc3ydbp8cpv77limn8d4s77szb2nrgl2r3h749";
  };

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    description = "Powerful extensions to the standard datetime module";
    homepage = http://pypi.python.org/pypi/python-dateutil;
    license = "BSD-style";
  };
}
