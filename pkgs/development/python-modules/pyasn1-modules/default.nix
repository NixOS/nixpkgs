{ stdenv, buildPythonPackage, fetchPypi, pyasn1, isPyPy }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "pyasn1-modules";
  version = "0.1.5";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1239h6h67vg0wazg2qgv6m3hdim2gs66pl89lbnayk55bbnkwc0x";
  };

  propagatedBuildInputs = [ pyasn1 ];

  meta = with stdenv.lib; {
    description = "A collection of ASN.1-based protocols modules";
    homepage = https://pypi.python.org/pypi/pyasn1-modules;
    license = licenses.bsd3;
    platforms = platforms.unix;  # same as pyasn1
  };
}
