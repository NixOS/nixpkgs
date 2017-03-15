{ stdenv, buildPythonPackage, persistent, zope_interface, transaction }:

buildPythonPackage rec {
  pname = "BTrees";
  version = "4.3.1";
  name = "${pname}-${version}";

  propagatedBuildInputs = [ persistent zope_interface transaction ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "15as34f9sa4nnd62nnjkik2jd4rg1byp0i4kwaqwdpv0ab9vfr95";
  };

  meta = with stdenv.lib; {
    description = "Scalable persistent components";
    homepage = http://packages.python.org/BTrees;
    license = licenses.zpt21;
  };
}
