{ stdenv, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
  pname = "py";
  version = "1.4.34";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qyd5z0hv8ymxy84v5vig3vps2fvhcf4bdlksb3r03h549fmhb8g";
  };

  # Circular dependency on pytest
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Library with cross-python path, ini-parsing, io, code, log facilities";
    homepage = http://pylib.readthedocs.org/;
    license = licenses.mit;
  };
}
